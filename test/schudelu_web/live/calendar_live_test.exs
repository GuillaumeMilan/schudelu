defmodule SchudeluWeb.CalendarLiveTest do
  use SchudeluWeb.ConnCase

  import Phoenix.LiveViewTest
  import Schudelu.ToolsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_calendar(_) do
    calendar = calendar_fixture()
    %{calendar: calendar}
  end

  describe "Index" do
    setup [:create_calendar]

    test "lists all calendar", %{conn: conn, calendar: calendar} do
      {:ok, _index_live, html} = live(conn, Routes.calendar_index_path(conn, :index))

      assert html =~ "Listing Calendar"
      assert html =~ calendar.name
    end

    test "saves new calendar", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.calendar_index_path(conn, :index))

      assert index_live |> element("a", "New Calendar") |> render_click() =~
               "New Calendar"

      assert_patch(index_live, Routes.calendar_index_path(conn, :new))

      assert index_live
             |> form("#calendar-form", calendar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#calendar-form", calendar: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.calendar_index_path(conn, :index))

      assert html =~ "Calendar created successfully"
      assert html =~ "some name"
    end

    test "updates calendar in listing", %{conn: conn, calendar: calendar} do
      {:ok, index_live, _html} = live(conn, Routes.calendar_index_path(conn, :index))

      assert index_live |> element("#calendar-#{calendar.id} a", "Edit") |> render_click() =~
               "Edit Calendar"

      assert_patch(index_live, Routes.calendar_index_path(conn, :edit, calendar))

      assert index_live
             |> form("#calendar-form", calendar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#calendar-form", calendar: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.calendar_index_path(conn, :index))

      assert html =~ "Calendar updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes calendar in listing", %{conn: conn, calendar: calendar} do
      {:ok, index_live, _html} = live(conn, Routes.calendar_index_path(conn, :index))

      assert index_live |> element("#calendar-#{calendar.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#calendar-#{calendar.id}")
    end
  end

  describe "Show" do
    setup [:create_calendar]

    test "displays calendar", %{conn: conn, calendar: calendar} do
      {:ok, _show_live, html} = live(conn, Routes.calendar_show_path(conn, :show, calendar))

      assert html =~ "Show Calendar"
      assert html =~ calendar.name
    end

    test "updates calendar within modal", %{conn: conn, calendar: calendar} do
      {:ok, show_live, _html} = live(conn, Routes.calendar_show_path(conn, :show, calendar))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Calendar"

      assert_patch(show_live, Routes.calendar_show_path(conn, :edit, calendar))

      assert show_live
             |> form("#calendar-form", calendar: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#calendar-form", calendar: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.calendar_show_path(conn, :show, calendar))

      assert html =~ "Calendar updated successfully"
      assert html =~ "some updated name"
    end
  end
end
