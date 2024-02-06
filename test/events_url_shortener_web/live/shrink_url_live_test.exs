
# TO DO: Figure out Auth and testing page
# defmodule EventsUrlShortenerWeb.ShrinkUrlLiveTest do
#   use EventsUrlShortenerWeb.ConnCase

#   import Phoenix.LiveViewTest
#   import EventsUrlShortener.ShrinkUrlsFixtures

#   @create_attrs %{hit_count: 42, url: "http://example.com"}
#   @update_attrs %{hit_count: 43, key: "some updated key", url: "http://example.com"}
#   @invalid_attrs %{hit_count: nil, key: nil, url: nil}

#   defp create_shrink_url(_) do
#     shrink_url = shrink_url_fixture()
#     %{shrink_url: shrink_url}
#   end

#   describe "Index" do
#     setup [:create_shrink_url]

#     test "lists all shrink_url", %{conn: conn, shrink_url: shrink_url} do
#       {:ok, _index_live, html} = live(conn, ~p"/shrink_url")

#       assert html =~ "Listing Shrink url"
#       assert html =~ shrink_url.key
#     end

#     test "saves new shrink_url", %{conn: conn} do
#       {:ok, index_live, _html} = live(conn, ~p"/shrink_url")

#       assert index_live |> element("a", "New Shrink url") |> render_click() =~
#                "New Shrink url"

#       assert_patch(index_live, ~p"/shrink_url/new")

#       assert index_live
#              |> form("#shrink_url-form", shrink_url: @invalid_attrs)
#              |> render_change() =~ "can&#39;t be blank"

#       assert index_live
#              |> form("#shrink_url-form", shrink_url: @create_attrs)
#              |> render_submit()

#       assert_patch(index_live, ~p"/shrink_url")

#       html = render(index_live)
#       assert html =~ "Shrink url created successfully"
#       assert html =~ "some key"
#     end

#     test "updates shrink_url in listing", %{conn: conn, shrink_url: shrink_url} do
#       {:ok, index_live, _html} = live(conn, ~p"/shrink_url")

#       assert index_live |> element("#shrink_url-#{shrink_url.id} a", "Edit") |> render_click() =~
#                "Edit Shrink url"

#       assert_patch(index_live, ~p"/shrink_url/#{shrink_url}/edit")

#       assert index_live
#              |> form("#shrink_url-form", shrink_url: @invalid_attrs)
#              |> render_change() =~ "can&#39;t be blank"

#       assert index_live
#              |> form("#shrink_url-form", shrink_url: @update_attrs)
#              |> render_submit()

#       assert_patch(index_live, ~p"/shrink_url")

#       html = render(index_live)
#       assert html =~ "Shrink url updated successfully"
#       assert html =~ "some updated key"
#     end

#     test "deletes shrink_url in listing", %{conn: conn, shrink_url: shrink_url} do
#       {:ok, index_live, _html} = live(conn, ~p"/shrink_url")

#       assert index_live |> element("#shrink_url-#{shrink_url.id} a", "Delete") |> render_click()
#       refute has_element?(index_live, "#shrink_url-#{shrink_url.id}")
#     end
#   end

#   describe "Show" do
#     setup [:create_shrink_url]

#     test "displays shrink_url", %{conn: conn, shrink_url: shrink_url} do
#       {:ok, _show_live, html} = live(conn, ~p"/shrink_url/#{shrink_url}")

#       assert html =~ "Show Shrink url"
#       assert html =~ shrink_url.key
#     end


#   end
# end
