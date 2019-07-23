(->
  load-file = (f, t) ~> new Promise (res, rej) ~>
    fr = new FileReader!
    fr.onload = -> res {result: fr.result, file: f}
    if t == \dataurl => fr.readAsDataURL f
    else if t == \text => fr.readAsText f, (@encoding or \utf-8)
    else if t == \binary => fr.readAsBinaryString f
    else if t == \arraybuffer or t == \blob => fr.readAsArrayBuffer f
    else if t == \blob => res f
    else if t == \bloburl => res URL.createObjectURL f
    else rej new Error("ldFile: un-supported type")

  ldFile = (opt = {}) ->
    @ <<< do
      evt-handler: {}
      opt: opt
      root: root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
      type: opt.type or \binary # valid type: <[dataurl text binary arraybuffer blob bloburl]>
      ldcv: opt.ldcv or null

    from-prompt = -> new Promise (res, rej) -> res ret = prompt!

    @root.addEventListener \change, (e) ~>
      files = e.target.files
      if !files.length => return
      promise = if @type == \text => (if @ldcv => @ldcv.get! else from-prompt!).then ~> @encoding = it
      else Promise.resolve!
      promise
        .then ~> Promise.all(Array.from(files).map (f) -> load-file f, type)
        .then ~> @fire \load, it
    @

  ldFile.prototype = Object.create(Object.prototype) <<< do
    on: (n, cb) -> @evt-handler.[][n].push cb
    fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v

  ldFile <<< do
    url: (u, t = \dataurl) ->
      new Promise (res, rej) ->
        r = new XMLHttpRequest!
        r.open \GET, u, true
        r.responseType = \blob
        r.onload = -> load-file(r.response, t) .then(res).catch(rej)
        r.send!

  if module? => module.exports = ldFile
  if window => window.ldFile = ldFile
)!
