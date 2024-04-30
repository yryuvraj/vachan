defmodule Vachan.Massmail.Workers.EnqueueEmails do
  use Oban.Worker,
    queue: :enqueue_emails

  alias Vachan.Massmail
  alias Vachan.Crm

  @impl true
  def perform(%Oban.Job{args: %{"campaign_id" => campaign_id} = _args}) do
    campaign =
      Massmail.Campaign.get_by_id!(campaign_id, authorize?: false, actor: nil)
      |> Massmail.load!(:list, authorize?: false, actor: nil)

    recepients = Crm.load!(campaign.list, :people, authorize?: false, actor: nil)

    recepients.people
    |> Enum.map(
      &(Oban.Job.new(%{campaign_id: campaign_id, recepient_id: &1.id},
          queue: :hydrate_emails,
          worker: Vachan.Massmail.Workers.HydrateEmails
        )
        |> Oban.insert())
    )

    :ok
  end
end

defmodule Vachan.Massmail.Workers.HydrateEmails do
  use Oban.Worker,
    queue: :hydrate_emails

  alias Vachan.Massmail
  alias Vachan.Crm

  # @impl true
  # def perform(%Oban.Job{args: args}) do
  #   IO.inspect(args)
  # end

  @impl true
  def perform(%Oban.Job{
        args: %{"campaign_id" => campaign_id, "recepient_id" => recepient_id} = _args
      }) do
    campaign = Massmail.Campaign.get_by_id!(campaign_id, authorize?: false, actor: nil)
    recepient = Crm.Person.get_by_id!(recepient_id, authorize?: false, actor: nil)

    body = EEx.eval_string(campaign.text_body, person: recepient)
    subject = EEx.eval_string(campaign.subject, person: recepient)

    message =
      Massmail.Message.create!(
        %{
          campaign_id: campaign.id,
          recepient_id: recepient.id,
          status: :queued,
          subject: subject,
          body: body
        },
        authorize?: false,
        actor: nil
      )

    Oban.Job.new(
      %{message_id: message.id},
      queue: :send_emails,
      worker: Vachan.Massmail.Workers.SendEmails
    )
    |> Oban.insert()

    :ok
  end
end

defmodule Vachan.Massmail.Workers.SendEmails do
  use Oban.Worker,
    queue: :send_emails

  import Swoosh.Email

  alias Vachan.Massmail
  @impl true
  def perform(%Oban.Job{args: %{"message_id" => message_id} = _args}) do
    message =
      Massmail.Message.get_by_id!(message_id, authorize?: false, actor: nil)
      |> Massmail.load!(:campaign, authorize?: false, actor: nil)
      |> Massmail.load!(:recepient, authorize?: false, actor: nil)

    campaign = message.campaign |> Massmail.load!(:sender_profile, authorize?: false, actor: nil)
    recepient = message.recepient
    sender_profile = campaign.sender_profile

    email =
      new()
      |> from({sender_profile.name, sender_profile.email})
      |> to({recepient.first_name <> " " <> recepient.last_name, recepient.email |> to_string})
      |> subject(message.subject)
      |> html_body(message.body)
      |> text_body(message.body)

    config = [
      relay: sender_profile.smtp_host,
      port: sender_profile.smtp_port,
      username: sender_profile.username,
      password: sender_profile.password,
      tls: :always
    ]

    case Swoosh.Adapters.SMTP.deliver(email, config) do
      {:ok, _} ->
        Massmail.Message.update!(message, %{status: :sent}, authorize?: false, actor: nil)

      {:error, _} ->
        Massmail.Message.update!(message, %{status: :failed}, authorize?: false, actor: nil)
    end
  end
end
