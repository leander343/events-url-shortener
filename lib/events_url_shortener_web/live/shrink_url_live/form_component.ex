defmodule EventsUrlShortenerWeb.ShrinkUrlLive.FormComponent do
  use EventsUrlShortenerWeb, :live_component

  alias EventsUrlShortener.ShrinkUrls

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Paste or type in URL to Shrink.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="shrink_url-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:url]} type="text" label="Url" />
        <:actions>
          <.button phx-disable-with="Saving...">Shrink url</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{shrink_url: shrink_url} = assigns, socket) do
    changeset = ShrinkUrls.change_shrink_url(shrink_url)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"shrink_url" => shrink_url_params}, socket) do
    changeset =
      socket.assigns.shrink_url
      |> ShrinkUrls.change_shrink_url(shrink_url_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"shrink_url" => shrink_url_params}, socket) do
    save_shrink_url(socket, socket.assigns.action, shrink_url_params)
  end

  defp save_shrink_url(socket, :edit, shrink_url_params) do
    case ShrinkUrls.update_shrink_url(socket.assigns.shrink_url, shrink_url_params) do
      {:ok, shrink_url} ->
        notify_parent({:saved, shrink_url})

        {:noreply,
         socket
         |> put_flash(:info, "Shrink url updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_shrink_url(socket, :new, shrink_url_params) do
    case ShrinkUrls.create_shrink_url(
           Map.new(shrink_url_params, fn {k, v} -> {String.to_atom(k), v} end)
         ) do
      {:ok, shrink_url} ->
        notify_parent({:saved, shrink_url})

        {:noreply,
         socket
         |> put_flash(:info, "URL Shrinked!")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
