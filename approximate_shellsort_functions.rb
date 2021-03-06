def shell_sort(a, accuracy = nil)
  iter = 0

  n = a.length

  h = 1 # increment factor

  while (h < n / 3)
      h = (3*h) + 1
  end

  while h >= 1
    for i in h...n
      j = i

      iter += 1 unless a[j] < a[j-h]

      while j >= h && a[j] < a[j-h]
        iter += 1

        if a[j-h] > a[j]
          a[j], a[j-h] = a[j-h], a[j]
        end
        j -= h

        closeness = coherence(a) if accuracy

        if accuracy && closeness > accuracy
          return [a, iter]
        end
      end
    end
    h /= 3
  end

  [a, iter]
end

def shell_sort_until(arr, &block)
  a = arr.dup
  iter = 0

  n = a.length

  h = 1 # increment factor

  while (h < n / 3)
      h = (3*h) + 1
  end

  while h >= 1
    for i in h...n
      j = i

      iter += 1 unless a[j] < a[j-h]

      while j >= h && a[j] < a[j-h]
        iter += 1

        if a[j-h] > a[j]
          a[j], a[j-h] = a[j-h], a[j]
        end
        j -= h

        return [a, iter] if block.call(a)

        # closeness = coherence(a) if accuracy
        #
        # if accuracy && closeness > accuracy
        #   return [a, iter]
        # end
      end
    end
    h /= 3
  end

  [a, iter]
end

$coherence_iter = 0

# TODO approximate coherence?

def coherence(elems, max_incoherence = nil)
  1.0 - calculate_incoherence(elems)
end

def calculate_coherence(elems)
  1.0 - calculate_incoherence(elems)
end

def calculate_incoherence(elems, max_incoherence = nil)
  max_incoherence = calculate_max_incoherence(elems.length) unless max_incoherence

  sum = elems.each_with_index.reduce(0) do |sum, (elem, i)|
    next sum if i > elems.length - 2

    sum + [0, (elem - elems[i+1]).abs - 1].max
  end
  # output = (sum.to_f / elems.length)

  sum.to_f / max_incoherence
end

def calculate_approximate_coherence(elems, buggy = false)

  max_incoherence = calculate_max_incoherence(elems.length)

  n = elems.length

  sample = (0...n-1).to_a.sample(Math.sqrt(n)*2)

  puts sample if buggy

  # this particular set of sample elements causes problems
  # I think they are too incoherent
  # I think [4, 5] might be the only coherent pair
  # these are the sample elements:
  # [[20, 39],
  # [73, 83],
  # [86, 37],
  # [35, 70],
  # [15, 6],
  # [1, 32],
  # [44, 33],
  # [30, 84],
  # [14, 86],
  # [43, 30],
  # [79, 23],
  # [58, 75],
  # [75, 8],
  # [49, 56],
  # [55, 14],
  # [4, 5],
  # [19, 82],
  # [60, 13]]

  sum = sample.reduce(0) do |sum, i|
    sum + [0, (elems[i] - elems[i+1]).abs - 1].max
  end
  # output = (sum.to_f / elems.length)

  # sum * Math.sqrt(n)

  sum = 1 - (sum * Math.sqrt(n)) / max_incoherence

  if sum < 0.0
    puts elems
    puts sum
    puts "actual coherence: #{coherence(elems)}"
    exit
  end

  sum
end

def puts(*str)
  str << "\n"
  things = str.reduce("") do |sum, elem|
    (unless sum.empty? then sum + ", " else "" end) + elem.to_s
  end

  print things
end

# TODO memoize
# min_incoherence is always = 0
$max_coherence_memo = {}

def calculate_max_incoherence(n)
  return 0 if n < 3
  return 1 if n == 3
  return $max_coherence_memo[n] if $max_coherence_memo.include?(n)

  (n / 2 - 1) * 2 + 1 + calculate_max_incoherence(n-1)
end


def min_incoherence_array(n)
  elems = (1..n).to_a
  elems[-2], elems[-1] = elems[-1], elems[-2]

  elems
end

def min_incoherence(n)
  calculate_incoherence(min_incoherence_array(n))
end

def min_coherence(n)
  coherence(min_incoherence_array(n))
end


def calculate_mini_incoherence

end
