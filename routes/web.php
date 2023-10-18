<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
/*Route::get('/', function () {
    return view('welcome');
});*/

Route::get('/', 'Front\FrontController@index');
Route::get('/test', 'Front\FrontController@test');

Route::group(['prefix' => 'admin'], function () {
    Voyager::routes();
});
