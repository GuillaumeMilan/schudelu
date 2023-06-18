#defmodule SchudeluWeb.ComponentsLive.ToggleComponent do
#
#  use SchudeluWeb, :live_component
#
#  def render(params) do
#    form = params.form
#    field = params.field
#    opts = params.opts
#    opts =
#      opts
#      |> Keyword.put_new(:type, "checkbox")
#      |> Keyword.put_new(:id, input_id(form, field))
#      |> Keyword.put_new(:name, input_name(form, field))
#
#    {value, opts} = Keyword.pop(opts, :value, input_value(form, field))
#    {checked_value, opts} = Keyword.pop(opts, :checked_value, true)
#    {unchecked_value, opts} = Keyword.pop(opts, :unchecked_value, false)
#    {hidden_input, opts} = Keyword.pop(opts, :hidden_input, true)
#
#    # We html escape all values to be sure we are comparing
#    # apples to apples. After all we may have true in the data
#    # but "true" in the params and both need to match.
#    value = html_escape(value)
#    checked_value = html_escape(checked_value)
#    unchecked_value = html_escape(unchecked_value)
#
#    opts =
#      if value == checked_value do
#        Keyword.put_new(opts, :checked, true)
#      else
#        opts
#      end
#
#    if hidden_input do
#      hidden_opts = [type: "hidden", value: unchecked_value]
#
#      html_escape([
#        tag(:input, hidden_opts ++ Keyword.take(opts, [:name, :disabled, :form])),
#        tag(:input, [value: checked_value] ++ opts)
#      ])
#    else
#      html_escape([
#        tag(:input, [value: checked_value] ++ opts)
#      ])
#    end
#    ~H"""
#    <div
#      class={"phx-toggle "<>@toggle_class}
#      phx-click="validate"
#    ><div class="phx-toggle-dot"></div></div>
#    """
#  end
#end
