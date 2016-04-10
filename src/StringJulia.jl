module StringJulia

import Base.getindex

getindex(s::ASCIIString, i::Int) = (i = i < 0 ? length(s) + i + 1 : i; s[i])
getindex(s::ASCIIString, r::UnitRange{Int}) = (r = first(r) < 0 ? (r + length(s) + 1) : r; s[r])

function getindex(s::UTF8String, i::Int)
  len = length(s)
  i < 0 && (i = len + i + 1)
  (0 < i <= len) || error("i is out of range")
  next(s, chr2ind(s, i))[1]
end

function getindex(s::UTF8String, r::UnitRange{Int})
  len = length(s)
  first_ = first(r) < 0 ? (len + 1 + first(r)) : first(r)
  last_ = last(r) < 0 ? (len + 1 + last(r)) : last(r)
  ((first_ < 1) || (last_ > len)) && error("i is out of range")

  substring = Array(Char, last_ - first_ + 1)
  for i in first_ : last_
    substring[i - first_ + 1] = s[i]
  end

  string(substring...)
end

export in

in(subchar::Char, string::AbstractString) = search(string, subchar) == 0 ? false:true
in(substring::AbstractString, string::AbstractString) = contains(string, substring)

end
