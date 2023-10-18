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
    <meta property="og:url" content="http://81.16.8.9:8888/">
    <meta property="og:type" content="website">
    <meta property="og:title" content="PES LEAGUE Online Championship">
    <meta property="og:description"
          content="Official website for PES LEAGUE Championship">
    <meta property="og:site_name" content="PES LEAGUE">
    <meta property="og:image" content="https://pesleague.konami.net/img/share_img_championship.jpg?v3">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="@officialpes">
    <meta name="twitter:image" content="https://pesleague.konami.net/img/share_img_championship.jpg?v3">

    <link rel="apple-touch-icon" href="http://81.16.8.9:8888/img/apple-touch-icon-precomposed.png">
    <link rel="shortcut icon" href="http://81.16.8.9:8888/favicon.ico" type="image/vnd.microsoft.icon">
    <link rel="icon" href="http://81.16.8.9:8888/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="http://81.16.8.9:8888/css/sc2-modern.css">
    <link rel="stylesheet" href="http://81.16.8.9:8888/css/style.css">

    <link href="http://81.16.8.9:8888/css/css.css" rel="stylesheet">
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
            <img src="/img/mv_online_cs_1v1.png" alt="PES LEAGUE ONLINE CHAMPIONSHIP 2018">
        </h1>
    </div>

    <section class="ranktbl">
        <h3>Global ranking</h3>
        <div class="inner" id="tgt-ranking">
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
        <div class="section section_trophy mix-section_divide mix-section_breath10 mix-section_breath12top">
            <div class="wrapper">
                <div class="vRythem vRythem_xlg">
                    <div class="grid">
                        <div class="grid-col grid-col_12of12">
                            <div data-recent-matches="" data-recent-matches-max="36">
                                <div class="contentBlock">
                                    <div class="contentBlock-hd contentBlock-hd_bordered"><h2 class="hdg hdg_2">
                                            Recent Matches</h2></div>
                                </div>
                                <div class="grid" data-recent-matches-no-matches="" style="display: none;">
                                    <div class="grid-col grid-col_2of12">&nbsp;</div>
                                    <div class="grid-col grid-col_8of12"><p class="txt txt_dim txt_euroExt">
                                            &nbsp;</p></div>
                                    <div class="grid-col grid-col_2of12">&nbsp;</div>
                                </div>
                                <div class="slideContainer isActive" data-component="SlideCarousel"
                                     data-slide-count-lg="3" data-slide-count-md="2" data-slide-count-sm="1"
                                     style="touch-action: pan-y; user-select: none; -webkit-user-drag: none; -webkit-tap-highlight-color: rgba(0, 0, 0, 0);">
                                    <div class="slideContainer-pager slideContainer-pager_posLeft"
                                         data-slide-ctrl="prev" style="height: 150px;">
                                        <div class="pager">
                                            <div class="pager-prev">&nbsp;</div>
                                        </div>
                                    </div>
                                    <div class="slideContainer-port" data-slide-port="" style="height: 362px;">
                                        <div class="blocks blocks_2up_phoneLg blocks_3up_tablet mix-blocks_mobileFirst mix-blocks_spaceMd mix-blocks_alignBottom"
                                             data-slide-shell=""
                                             style="transform: translate(-816.656px, 0px); width: 1225%;">
                                            <!-- We should always have at least 2 competitors that are not null.-->
                                            <!-- This case was added because there is a chance we can get matches-->
                                            <!-- that do not have any competitor data due to user-error in the entry.-->
                                            @foreach ($events as $event)
                                                <div class="matchup"
                                                     style="width: 2.77778%; position: static; left: auto;">
                                                    <div class="matchup-graphic" data-slide-sizer="">
                                                        <a class="matchup-graphic-link" href="#"><span class="isVisuallyHidden">Watch VOD</span></a>
                                                        <div class="matchup-graphic-flexbox">
                                                            <div class="matchup-graphic-player">
                                                                <div class="matchup-graphic-player-img">
                                                                    <div data-hex-img-width="100"
                                                                         data-hex-inner-frame-width="5"
                                                                         data-hex-outer-frame-width="0"
                                                                         data-hex-img-stroke-width="3"
                                                                         data-hex-img-src="public/img/win-logo.png">
                                                                        <canvas width="106" height="106"></canvas>
                                                                    </div>
                                                                </div>
                                                                <div class="matchup-graphic-player-name">
                                                                    <div class="txt_center txt_std txt_euro txt_bold">
                                                                        {{ $event->getPlayer1()->nick }}
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="matchup-graphic-details">
                                                                <div class="matchup-graphic-details-top"></div>
                                                                <div class="matchup-graphic-details-bottom">
                                                                    <div class="matchup-vs txt_euro txt_upper txt_xlarge txt_spc">
                                                                        vs
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="matchup-graphic-player">
                                                                <div class="matchup-graphic-player-img">
                                                                    <div data-hex-img-width="100"
                                                                         data-hex-inner-frame-width="5"
                                                                         data-hex-outer-frame-width="0"
                                                                         data-hex-img-stroke-width="3"
                                                                         data-hex-img-src="public/img/win-logo.png">
                                                                        <canvas width="106" height="106"></canvas>
                                                                    </div>
                                                                </div>
                                                                <div class="matchup-graphic-player-name">
                                                                    <div class="txt_center txt_std txt_euro txt_bold">
                                                                        {{ $event->getPlayer2()->nick }}
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    {{--<div class="matchup-scores">--}}
                                                    {{--<div class="spoiler" data-spoiler-scrim=""--}}
                                                    {{--style="display: none;">Scores Hidden--}}
                                                    {{--</div>--}}
                                                    {{--<div class="matchup-rank-item matchup-rank-item_winner"--}}
                                                    {{--data-href="http://81.16.8.9:8888/en-us/player/2335/">--}}
                                                    {{--<div class="matchup-rank-item-img"><img--}}
                                                    {{--src="./3_files/Finland.png"></div>--}}
                                                    {{--<div class="matchup-rank-item-img"><img--}}
                                                    {{--class="playerInfo_race"--}}
                                                    {{--src="./3_files/zergIcon.png"></div>--}}
                                                    {{--<div class="matchup-rank-item-name"><span--}}
                                                    {{--class="txt txt_md txt_spc"><a--}}
                                                    {{--href="https://wcs.starcraft2.com/en-us/player/2335/">Serral</a></span>--}}
                                                    {{--</div>--}}
                                                    {{--<div class="matchup-rank-item-score"><span>4</span>--}}
                                                    {{--</div>--}}
                                                    {{--</div>--}}
                                                    {{--<div class="matchup-rank-item"--}}
                                                    {{--data-href="http://81.16.8.9:8888/en-us/player/2062/">--}}
                                                    {{--<div class="matchup-rank-item-img"><img--}}
                                                    {{--src="./3_files/Taiwan.png"></div>--}}
                                                    {{--<div class="matchup-rank-item-img"><img--}}
                                                    {{--class="playerInfo_race"--}}
                                                    {{--src="./3_files/protossIcon.png"></div>--}}
                                                    {{--<div class="matchup-rank-item-name"><span--}}
                                                    {{--class="txt txt_md txt_spc"><a--}}
                                                    {{--href="https://wcs.starcraft2.com/en-us/player/2062/">Has</a></span>--}}
                                                    {{--</div>--}}
                                                    {{--<div class="matchup-rank-item-score"><span>1</span>--}}
                                                    {{--</div>--}}
                                                    {{--</div>--}}
                                                    {{--</div>--}}
                                                </div>
                                            @endforeach

                                        </div>
                                    </div>
                                    <div class="slideContainer-pager slideContainer-pager_posRight"
                                         data-slide-ctrl="next" style="height: 150px;">
                                        <div class="pager">
                                            <div class="pager-next">&nbsp;</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <nav>
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