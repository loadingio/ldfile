ldFile = (opt = {}) ->
  @ <<< do
    evt-handler: {}
    opt: opt
    root: root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
    type: opt.type or \binary # valid type: <[dataurl text binary arraybuffer blob bloburl]>
  load-file = (f) ~> new Promise (res, rej) ~>
    fr = new FileReader!
    fr.onload = -> res {result: fr.result, file: f}
    if @type == \dataurl => fr.readAsDataURL f
    else if @type == \text => fr.readAsText f, (@encoding or \utf-8)
    else if @type == \binary => fr.readAsBinaryString f
    else if @type == \arraybuffer or @type == \blob => fr.readAsArrayBuffer f
    else if @type == \blob => res f
    else if @type == \bloburl => res URL.createObjectURL f
    else rej new Error("ldFile: un-supported ytpe")

  from-prompt = -> new Promise (res, rej) -> res ret = prompt!

  @root.addEventListener \change, (e) ~>
    files = e.target.files
    if !files.length => return
    promise = if @type == \text => (if @ldcv => @ldcv.get! else from-prompt!).then ~> @encoding = it
    else Promise.resolve!
    promise
      .then ~> Promise.all(Array.from(files).map (f) -> load-file f)
      .then ~> @fire \load, it
  @

ldFile.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v

