defmodule ElixirKatas.CSV do
  NimbleCSV.define(MyParser, separator: ",", escape: "\"")
end
