# defmodule EventsUrlShortener.ShrinkUrlsTest do
#   use EventsUrlShortener.DataCase

#   alias EventsUrlShortener.ShrinkUrls

#   describe "shrink_url" do
#     alias EventsUrlShortener.ShrinkUrls.ShrinkUrl

#     import EventsUrlShortener.ShrinkUrlsFixtures

#     @invalid_attrs %{hit_count: nil, key: nil, url: nil}

#     test "list_shrink_url/0 returns all shrink_url" do
#       shrink_url = shrink_url_fixture()
#       assert ShrinkUrls.get_shrink_url() == [shrink_url]
#     end

#     test "get_shrink_url!/1 returns the shrink_url with given id" do
#       shrink_url = shrink_url_fixture()
#       assert ShrinkUrls.get_shrink_url_by_key!(shrink_url.key) == shrink_url
#     end

#     test "create_shrink_url/1 with valid data creates a shrink_url" do
#       valid_attrs = %{hit_count: 42, key: "some key", url: "some url"}

#       assert {:ok, %ShrinkUrl{} = shrink_url} = ShrinkUrls.create_shrink_url(valid_attrs)
#       assert shrink_url.hit_count == 42
#       assert shrink_url.url == "some url"
#     end

#     test "create_shrink_url/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = ShrinkUrls.create_shrink_url(@invalid_attrs)
#     end

#     test "update_shrink_url/2 with valid data updates the shrink_url" do
#       shrink_url = shrink_url_fixture()
#       update_attrs = %{hit_count: 43, key: "some updated key", url: "some updated url"}

#       assert {:ok, %ShrinkUrl{} = shrink_url} =
#                ShrinkUrls.update_shrink_url(shrink_url, update_attrs)

#       assert shrink_url.hit_count == 43
#       assert shrink_url.url == "some updated url"
#     end

#     test "update_shrink_url/2 with invalid data returns error changeset" do
#       shrink_url = shrink_url_fixture()

#       assert {:error, %Ecto.Changeset{}} =
#                ShrinkUrls.update_shrink_url(shrink_url, @invalid_attrs)

#       assert shrink_url == ShrinkUrls.get_shrink_url!(shrink_url.id)
#     end

#     test "delete_shrink_url/1 deletes the shrink_url" do
#       shrink_url = shrink_url_fixture()
#       assert {:ok, %ShrinkUrl{}} = ShrinkUrls.delete_shrink_url(shrink_url)
#       assert_raise Ecto.NoResultsError, fn -> ShrinkUrls.get_shrink_url!(shrink_url.id) end
#     end

#     test "change_shrink_url/1 returns a shrink_url changeset" do
#       shrink_url = shrink_url_fixture()
#       assert %Ecto.Changeset{} = ShrinkUrls.change_shrink_url(shrink_url)
#     end
#   end
# end
