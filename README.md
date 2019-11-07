# webcomicr

A simple tool for fetching webcomics from their websites and keeping them in storage. Runs off `~/.comics`, which is a JSON file with the following contents for each comic:
```json
{
  "Name": {
    "path": "The Folder to save the images in",
    "base_url": "The part of the URL common to all episodes",
    "last_page_indicator": "Text only appearing on the last page of the comic",
    "next_link": "RegEx for the link to the next page, with a capture group inside the href attribute value",
    "image": "RegEx for the image to download, with a capture group inside the src attribute value",
    "override_user_agent": "Optional: Send this string as User-Agent header to circumvent blocks"
  }
}
```

After creating the file with its respective values and the storage folder, run `webcomicr Name url-of-the-first-episode` to start downloading from the beginning. Afterwards you can just use `webcomicr Name` to check for and download new episodes.

## Contributing

1. Fork it (<https://github.com/deingithub/webcomicr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Cassidy Dingenskirchen](https://github.com/deingithub) - creator and maintainer
