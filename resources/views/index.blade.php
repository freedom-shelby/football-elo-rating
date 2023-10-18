<!DOCTYPE html>
<html lang="en" class=" responsejs ">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>PES LEAGUE Championship</title>
    <meta name="description"
          content="Official website for PES LEAGUE Championship 2018">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="format-detection" content="telephone=no">
    <meta property="og:url" content="http://efootball.arsenhovhannisyan.com/">
    <meta property="og:type" content="website">
    <meta property="og:title" content="PES LEAGUE Online Championship">
    <meta property="og:description"
          content="Official website for PES LEAGUE Championship">
    <meta property="og:site_name" content="PES LEAGUE">
    <meta property="og:image" content="https://pesleague.konami.net/img/share_img_championship.jpg?v3">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@officialpes">
    <meta name="twitter:image" content="https://pesleague.konami.net/img/share_img_championship.jpg?v3">

    <link rel="apple-touch-icon" href="/img/apple-touch-icon-precomposed.png">
    <link rel="shortcut icon" href="/favicon.ico" type="image/vnd.microsoft.icon">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    {{--<link rel="stylesheet" href="/css/sc2-modern.css">--}}
    <link rel="stylesheet" href="/css/style.css">

    <link href="/css/css.css" rel="stylesheet">
</head>
<span id="warning-container"><i data-reactroot=""></i></span>
<body class="championship_ c1v1_ ranking championship_1v1_ranking round pc">
<div id="wrapper">
    <header>
        <div class="main-menu">
            <div class="inner">
                <p class="logo-psl">
                    <a href="/">PES LEAGUE</a>
                </p>
                <nav itemscope="itemscope" itemtype="http://www.schema.org/SiteNavigationElement">
                    <p itemprop="name">
                        <a href="#">
                            <span>REGISTER</span>
                        </a>
                    </p>
                </nav>
            </div>
        </div>
    </header>
    <div class="mv">
        <h1>
            <img src="/img/pes-league.png" alt="PES LEAGUE ONLINE CHAMPIONSHIP 2020" title="PES League">
        </h1>
    </div>

    <section class="ranktbl">
        <h3>Global ranking</h3>
        <div class="inner" id="tgt-ranking">
            <div class="filter">

                <dl class="filter-dlparts-season">
                    <dt>Season</dt>
                    <dd class="option-parts">
                        <p>All time</p>
                        <select name="season">

                            <option value="_all_">All time</option>

                            <?foreach (\App\Models\Tournament::active()->get() as $item):?>
                                <option value="{{ $item->id }}">{{ $item->name }}</option>
                            <?endforeach?>

                        </select>
                    </dd>
                </dl>

                <p class="btn">
                    <a href="#" id="search-seassion"><span>Search</span></a>
                </p>
            </div>
            <div class="result">
                <div class="scrollable">
                    <table id="resultstable">
                        <thead>
                        <tr>
                            <th>Rank</th>
                            <td class="pname">Name</td>
                            <td class="win_point">Rating</td>
                            <td class="win">Won</td>
                            <td class="draw">Draw</td>
                            <td class="lose">Lost</td>
                            <td class="goals">Games</td>
                            <td class="goals">Win Rate</td>
                        </tr>
                        </thead>
                        <tbody>

                        @foreach($players as $player)
                            <tr>
                                <td>{{ $loop->iteration }}</td>
                                <td>{{ $player->nick }}</td>
                                <td>{{ $player->rating }}</td>
                                <td>{{ $player->won }}</td>
                                <td>{{ $player->draw }}</td>
                                <td>{{ $player->lost }}</td>
                                <td>{{ $player->games }}</td>
                                <td>{{ $player->winRate }}%</td>
                            </tr>
                        @endforeach

                        </tbody>
                    </table>
                </div>
                <div id="ranking-loading" style="display: none;">
                    <svg version="1.1" id="" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="100px"
                         height="100px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
                        <polygon class="loading" fill="none" stroke="#000" stroke-miterlimit="10"
                                 points="15.4,30 50,10 84.6,30 84.6,70 50,90 15.4,70 ">
                        </polygon>
                    </svg>
                    <p>loading..</p>
                </div>
            </div>
        </div>
    </section>

    <footer>
        {{--<div class="section section_trophy mix-section_divide mix-section_breath10 mix-section_breath12top">--}}
            {{--@foreach ($events as $event)--}}
                {{--<div class="matchup"--}}
                     {{--style="width: 2.77778%; position: static; left: auto;">--}}
                    {{--<div class="matchup-graphic" data-slide-sizer="">--}}
                        {{--<a class="matchup-graphic-link" href="#"><span class="isVisuallyHidden">Watch VOD</span></a>--}}
                        {{--<div class="matchup-graphic-flexbox">--}}
                            {{--<div class="matchup-graphic-player">--}}
                                {{--<div class="matchup-graphic-player-img">--}}
                                    {{--<div data-hex-img-width="100"--}}
                                         {{--data-hex-inner-frame-width="5"--}}
                                         {{--data-hex-outer-frame-width="0"--}}
                                         {{--data-hex-img-stroke-width="3"--}}
                                         {{--data-hex-img-src="/img/win-logo.png">--}}
                                        {{--<canvas width="106" height="106"></canvas>--}}
                                    {{--</div>--}}
                                {{--</div>--}}
                                {{--<div class="matchup-graphic-player-name">--}}
                                    {{--<div class="txt_center txt_std txt_euro txt_bold">--}}
                                        {{--{{ $event->getPlayer1()->nick }}--}}
                                    {{--</div>--}}
                                {{--</div>--}}
                            {{--</div>--}}
                            {{--<div class="matchup-graphic-details">--}}
                                {{--<div class="matchup-graphic-details-top"></div>--}}
                                {{--<div class="matchup-graphic-details-bottom">--}}
                                    {{--<div class="matchup-vs txt_euro txt_upper txt_xlarge txt_spc">--}}
                                        {{--vs--}}
                                    {{--</div>--}}
                                {{--</div>--}}
                            {{--</div>--}}
                            {{--<div class="matchup-graphic-player">--}}
                                {{--<div class="matchup-graphic-player-img">--}}
                                    {{--<div data-hex-img-width="100"--}}
                                         {{--data-hex-inner-frame-width="5"--}}
                                         {{--data-hex-outer-frame-width="0"--}}
                                         {{--data-hex-img-stroke-width="3"--}}
                                         {{--data-hex-img-src="/img/win-logo.png">--}}
                                        {{--<canvas width="106" height="106"></canvas>--}}
                                    {{--</div>--}}
                                {{--</div>--}}
                                {{--<div class="matchup-graphic-player-name">--}}
                                    {{--<div class="txt_center txt_std txt_euro txt_bold">--}}
                                        {{--{{ $event->getPlayer2()->nick }}--}}
                                    {{--</div>--}}
                                {{--</div>--}}
                            {{--</div>--}}
                        {{--</div>--}}
                    {{--</div>--}}
                {{--</div>--}}
            {{--@endforeach--}}
        {{--</div>--}}
        <nav>
            <div class="center">
                <img src="/img/logo-pes-2020.png" alt="PES LEAGUE ONLINE CHAMPIONSHIP 2018">
            </div>
            <ul>
                <li><a href="#">register</a></li>
            </ul>
        </nav>
        <p class="copy">©2018 ArmSALArm</p>
    </footer>
</div>

<script src="/js/jquery.min.js" type="text/javascript"></script>
<script src="/js/underscore-min.js" type="text/javascript"></script>
<script src="/js/response.min.js" type="text/javascript"></script>
<script src="/js/common.js" type="text/javascript"></script>

</body>
</html>