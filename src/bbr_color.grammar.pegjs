main 
  = lines:(line+) EOT { return lines }

line
  = row:(row) { return row }
  / (!(EOT .*) comment:(comment) { return comment } )

row
  = _ K:TEMPERATURE __ CMF:ROTATION __ x:FLOAT __ y:FLOAT __ P:SCIENTIFIC_NUMBER __ R:FLOAT __ G:FLOAT __ B:FLOAT __ r:INTEGER __ g:INTEGER __ b:INTEGER __ rgb:HEX_COLOR EOL { return {kind: "ROW", data: {K, CMF, x, y, P, R, G, B, r,g,b, rgb}} }

comment
  = "#" " "? comment:(NOT_EOL*) EOL {return {kind: "COMMENT", text: comment.join("")} }

EOT
  = "# end" _

HEX_COLOR
  = color:("#" [0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]) { return color.join(""); }

ROTATION
  = rotation:(("2"/"10") "deg") { return rotation.join("") }

SCIENTIFIC_NUMBER
  = scientific_number:(FLOAT [eE] [+-] DIGIT+) { return Number(scientific_number.flat().join("")) }

FLOAT
  = float:(INTEGER "." DIGIT+) { return parseFloat(float.flat().join("")) }

TEMPERATURE
  = temperature:(INTEGER __ "K") { return parseInt(temperature.join("").slice(0,-1)) }

INTEGER
  = integer:([1-9] DIGIT* / "0") { return parseInt(integer.flat ? integer.flat().join("") : integer) }

DIGIT
  = digit:([0-9]) { return digit }

_ "optional whitespace"
  = [ \t\r\n]* { return undefined }

__ "mandatory whitespace"
  = [ \t]+ { return undefined }

EOL
  = [\n\r]+ { return undefined }

NOT_EOL
  = [^\n\r]
