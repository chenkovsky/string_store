# string_store

Convert String to Hash Value. Using Hash Value to represent String improves performance of String Searching in HashTable.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  string_store:
    github: chenkovsky/string_store
```

## Usage

```crystal
require "string_store"
it "works" do
    store = StringStore.new
    id = store.get_id "example"
    store.to_disk("store.bin")
    store = StringStore.from_disk("store.bin")
    store.get_id("example").should eq(id)
end
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/string_store/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [chenkovsky](https://github.com/chenkovsky) chenkovsky - creator, maintainer
