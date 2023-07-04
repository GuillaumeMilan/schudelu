defmodule SchudeluWeb.SvgIconsView do
  use SchudeluWeb, :view

  def icon(%{name: name}), do: Phoenix.View.render(__MODULE__, "#{name}.svg", [])
end
