run Proc.new { |env|
  # sleep rand
  ['200', {'Content-Type' => 'text/html'}, ['slow']]
}