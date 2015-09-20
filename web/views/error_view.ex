defmodule Coders.ErrorView do
  use Coders.Web, :view

  def render("400.json", %{reason: reason}) do
    case reason do
      %Coders.InvalidData{message: msg, errors: nil} ->
        error_object msg
      %Coders.InvalidData{model: model, errors: errors} ->
        # Poison can't encode Keyword by default
        errors = Enum.reduce errors, [], fn e, acc ->
          [[elem(e, 0), elem(e, 1)] | acc]
        end
        error_object errors, %{resource: model.__schema__(:source)}
      _ -> error_object reason.message
    end
  end

  def render("500.json", %{reason: reason}) do
    error_object inspect(reason)
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end

  # a convenience function to generate JSON error object.
  defp error_object(msg, extra \\ %{}) do
    Map.merge(%{status: :error, message: msg}, extra)
  end
end
