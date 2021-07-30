load-file = (f, t = \binary, e) ~> new Promise (res, rej) ~>
  fr = new FileReader!
  fr.onload = -> res {result: fr.result, file: f}
  if t == \dataurl => fr.readAsDataURL f
  else if t == \text => fr.readAsText f, (e or \utf-8)
  else if t == \binary => fr.readAsBinaryString f
  else if t == \arraybuffer or t == \blob => fr.readAsArrayBuffer f
  # should we simply use this for blob type?
  # else if t == \blob => res {file: f}
  else if t == \bloburl => res {result: URL.createObjectURL(f), file: f}
  else rej new Error("[ldfile] un-supported type")

ldfile = (opt = {}) ->
  @ <<< do
    evt-handler: {}
    opt: opt
    root: root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
    type: opt.type or \binary # valid type: <[dataurl text binary arraybuffer blob bloburl]>
    ldcv: opt.ldcv or null
    encoding: opt.force-encoding

  from-prompt = -> new Promise (res, rej) -> res ret = prompt("encoding:", "utf-8")

  @root.addEventListener \change, (e) ~>
    files = e.target.files
    if !files.length => return
    promise = if @type == \text and !opt.force-encoding =>
      (if @ldcv => @ldcv.get! else from-prompt!).then ~> @encoding = it
    else Promise.resolve!
    promise
      .then ~> Promise.all(Array.from(files).map (f) ~> load-file f, @type, @encoding)
      .then ~> @fire \load, it
  @

ldfile.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v

ldfile <<< do
  fromURL: (u, t, e) ->
    new Promise (res, rej) ->
      r = new XMLHttpRequest!
      r.open \GET, u, true
      r.responseType = \blob
      r.onload = -> load-file(r.response, t, e) .then(res).catch(rej)
      r.send!
  fromFile: (f, t, e) -> load-file f, t, e
  download: (opt={}) ->
    if opt.href => href = that
    else href = URL.createObjectURL(if opt.blob => that else new Blob([opt.data], {type: opt.mime}))
    n = document.createElement \a
    n.setAttribute \href, href
    n.setAttribute \download, opt.name or 'untitled'
    document.body.appendChild n
    n.click!
    document.body.removeChild n

if module? => module.exports = ldfile
else if window? => window.ldfile = ldfile
