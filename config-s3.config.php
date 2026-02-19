<?php
$CONFIG = [
  'objectstore' => [
    'class' => '\\OC\\Files\\ObjectStore\\S3',
    'arguments' => [
      'bucket' => 'nextcloud-bucket',
      'key' => getenv('AWS_CREDENTIALS') ?: 'test',
      'secret' => getenv('AWS_SECRET') ?: 'test',
      'hostname' => 'localstack',
      'port' => 4566,
      'use_ssl' => false,
      'use_path_style' => true,
      'autocreate' => true,
      'region' => 'us-east-1',
    ],
  ],
];
