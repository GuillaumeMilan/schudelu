defmodule SchudeluWeb.EventVertexLiveTest do
  use SchudeluWeb.ConnCase

  import Phoenix.LiveViewTest
  import Schudelu.ToolsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_event_vertex(_) do
    event_vertex = event_vertex_fixture()
    %{event_vertex: event_vertex}
  end

  describe "Index" do
    setup [:create_event_vertex]

    test "lists all event_vertex", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.event_vertex_index_path(conn, :index))

      assert html =~ "Listing Event vertex"
    end

    test "saves new event_vertex", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.event_vertex_index_path(conn, :index))

      assert index_live |> element("a", "New Event vertex") |> render_click() =~
               "New Event vertex"

      assert_patch(index_live, Routes.event_vertex_index_path(conn, :new))

      assert index_live
             |> form("#event_vertex-form", event_vertex: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#event_vertex-form", event_vertex: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.event_vertex_index_path(conn, :index))

      assert html =~ "Event vertex created successfully"
    end

    test "updates event_vertex in listing", %{conn: conn, event_vertex: event_vertex} do
      {:ok, index_live, _html} = live(conn, Routes.event_vertex_index_path(conn, :index))

      assert index_live |> element("#event_vertex-#{event_vertex.id} a", "Edit") |> render_click() =~
               "Edit Event vertex"

      assert_patch(index_live, Routes.event_vertex_index_path(conn, :edit, event_vertex))

      assert index_live
             |> form("#event_vertex-form", event_vertex: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#event_vertex-form", event_vertex: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.event_vertex_index_path(conn, :index))

      assert html =~ "Event vertex updated successfully"
    end

    test "deletes event_vertex in listing", %{conn: conn, event_vertex: event_vertex} do
      {:ok, index_live, _html} = live(conn, Routes.event_vertex_index_path(conn, :index))

      assert index_live |> element("#event_vertex-#{event_vertex.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#event_vertex-#{event_vertex.id}")
    end
  end

  describe "Show" do
    setup [:create_event_vertex]

    test "displays event_vertex", %{conn: conn, event_vertex: event_vertex} do
      {:ok, _show_live, html} = live(conn, Routes.event_vertex_show_path(conn, :show, event_vertex))

      assert html =~ "Show Event vertex"
    end

    test "updates event_vertex within modal", %{conn: conn, event_vertex: event_vertex} do
      {:ok, show_live, _html} = live(conn, Routes.event_vertex_show_path(conn, :show, event_vertex))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Event vertex"

      assert_patch(show_live, Routes.event_vertex_show_path(conn, :edit, event_vertex))

      assert show_live
             |> form("#event_vertex-form", event_vertex: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#event_vertex-form", event_vertex: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.event_vertex_show_path(conn, :show, event_vertex))

      assert html =~ "Event vertex updated successfully"
    end
  end
end
