ovh::oco::check { 'http':
  freq      => '300sec',
  http_path => '/my-health-check.php',
}
