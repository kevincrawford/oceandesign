unless typeof String::startsWith is "function"
  String::startsWith = (str) ->
    @slice(0, str.length) is str

unless typeof String::endsWith is "function"
  String::endsWith = (str) ->
    @slice(-str.length) is str