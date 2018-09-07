formatter = "%{first} %{second} %{third} %{fourth}"

lil = "lil"
puts formatter % {
  first: 'lol',
  second: lil,
  third: 3,
  fourth: "ha\v haha"
}
