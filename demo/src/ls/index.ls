ldcv = new ldCover root: '.ldcv'
ldf = new ldFile root: \input, type: \text, ldcv: ldcv
ldf.on \load, -> textarea.value = it.map(-> it.result).join(\\n)

