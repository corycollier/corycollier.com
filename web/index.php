<?php

// web/index.php
require_once __DIR__ . '/../vendor/autoload.php';

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

$app = new Silex\Application();

/**
 * function to handle the response as an html view.
 *
 * @param  string $filename the translated path for the filename.
 *
 * @return Response A Symfony Response object.
 */
function view($filename, $status = 200) {
    $raw = file_get_contents($filename);
    $parse = new Parsedown();
    $contents = $parse->text($raw);

    $layout = file_get_contents(__DIR__ . '/layout.html');

    $result = strtr($layout, [
        '{CONTENT}' => $contents,
    ]);

    return new Response($result, $status);
};

/**
 * Gets a markdown filename from a given path.
 * @param  string $path The raw path requested.
 * @return string The path to the markdown file.
 */
function filename($path) {
    if (! $file && $_SERVER['REQUEST_URI'] !== '/index.php') {
        $file = $_SERVER['REQUEST_URI'];
    }
    $file = strtr($path, [
        '/'     => '_',
        '.html' => '.md',
    ]);

    if (!$file) {
        $file = 'index.md';
    }


    $filename = __DIR__ . '/../data/' . $file;

    return $filename;
}

// Match the requests
$app->match('{url}', function ($url) use ($app) {
    $filename = filename($url);

    if (! file_exists($filename)) {
        throw new ErrorException('Not found');
    }
    return view($filename);

})->assert('url', '.*');

// Handle the problems
$app->error(function(\Exception $exception, Request $request, $code) {
    $filename = filename('404.html');
    return view($filename, 404);
});

// Get some.
$app->run();
