defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>ForgotPasswordLive do
  use <%= inspect context.web_module %>, :live_view

  alias <%= inspect context.module %>

  def render(assigns) do
    ~H"""
    <h1>Forgot your password?</h1>

    <.form id="reset_password_form" :let={f} for={:<%= schema.singular %>} phx-submit="send_email">
      <%%= label f, :email %>
      <%%= email_input f, :email, required: true %>

      <div>
        <%%= submit "Send instructions to reset password" %>
      </div>
    </.form>

    <.link href={~p"<%= schema.route_prefix %>/register"}>Register</.link> |
    <.link href={~p"<%= schema.route_prefix %>/log_in"}>Log in</.link>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("send_email", %{"<%= schema.singular %>" => %{"email" => email}}, socket) do
    if <%= schema.singular %> = <%= inspect context.alias %>.get_<%= schema.singular %>_by_email(email) do
      <%= inspect context.alias %>.deliver_<%= schema.singular %>_reset_password_instructions(
        <%= schema.singular %>,
        &url(~p"<%= schema.route_prefix %>/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
