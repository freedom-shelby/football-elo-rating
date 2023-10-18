/*
 * common.js（jQuery、underscore.js必須）
 */

/* ユーティリティ系 */

/*
 * 改行コードを<br>に。
 */
function nl2br(str){
	return (str.replace(/\r\n/g, "<br />")).replace(/[\n\r]/g, "<br />");
}
/*
 * 数値を3ケタ区切り
 */
function addFigure(str){
	return String(str).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
}

/**
 * 日付をフォーマットする
 * @param  {Date}   date     日付
 * @param  {String} [format] フォーマット
 * @return {String}          フォーマット済み日付
 */
function formatDate(date, format){
	if(!format) format = window.date_format ? window.date_format : 'YYYY.MM.DD hh:mm';
	var weekdaylist = ["日", "月", "火", "水", "木", "金", "土"];
	format = format.replace(/YYYY/g, date.getFullYear());
	format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2));
	format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2));
	format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2));
	format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2));
	format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2));
	format = format.replace(/WD/g, weekdaylist[date.getDay()]);
	if(format.match(/S/g)){
		var milliSeconds = ('00' + date.getMilliseconds()).slice(-3);
		var length = format.match(/S/g).length;
		for(var i = 0; i < length; i++) format = format.replace(/S/, milliSeconds.substring(i, i + 1));
	}
	return format;
}

window.jQuery && (function($, _) {
	// Response設定
	var width_breakpoints = [0,320,480,768,980];
	Response.create([
		{prop: "width",prefix: "src",breakpoints: width_breakpoints, lazy: true},
		{prop: "device-pixel-ratio",prefix: "ratio",breakpoints: [0,2], lazy: true}
	]);
	// レスポンシブ用のコントローラー
	window.ResponseController = {
		breakpointEvents:[],
		init:function(){
			var that = this;
			Response.crossover(function(){
				var breakpoint = that.getCurrentBreakPoint();
				that.runBreakPointEvents(breakpoint);
			},"width");
		},
		setEvent:function(fn,parent){
			parent = parent || window;
			this.breakpointEvents[this.breakpointEvents.length] = {fn:fn,parent:parent};
			return;
		},
		runBreakPointEvents:function(breakpoint){
			for(var i=0;i<this.breakpointEvents.length;i++){
				this.breakpointEvents[i].fn.call(this.breakpointEvents[i].parent,breakpoint);
			}
			return;
		},
		getCurrentBreakPoint:function(){
			var breakpoint = 0
			for(var i=0;i<width_breakpoints.length;i++){
				if(Response.band(width_breakpoints[i])){
					breakpoint = width_breakpoints[i];
				}else{
					break;
				}
			}
			return breakpoint;
		}
	};
	ResponseController.init();

	/*
	 * ハッシュコントローラー
	 * @param なし
	 * @return なし
	 */
	window.hashChangeController = {
		hashChangeEvents:[],
		hashChangeEventsByHash:{},
		init:function(){
			var that= this;
			$(window).bind("hashchange",that.runHashChangeEvents);
			return;
		},
		setEvent:function(obj){
			if(!obj || !obj.fn){return;}
			var hash = this.getHash();
			obj.parent = obj.parent||window;
			this.hashChangeEvents[this.hashChangeEvents.length] = {fn:obj.fn,parent:obj.parent};
			// セットされたタイミングで処理
			if(obj.first){
				if(_.isNumber(obj.first)){
					setTimeout(function(){
						obj.fn.call(obj.parent,hash);
					},obj.first);
				}else{
					obj.fn.call(obj.parent,hash);
				}

			}
			return;
		},
		setEventByHash:function(obj_ary){
			if(!obj_ary || !obj_ary.length){return;}
			var that = this;
			var hash = this.getHash();
			_.each(obj_ary,function(obj){
				if(!obj.fn || !obj.hash){return;}
				obj.parent = obj.parent||window;
				that.hashChangeEventsByHash[obj.hash] = {fn:obj.fn,parent:obj.parent};
				if(hash == obj.hash){
					obj.fn.call(obj.parent,hash);
				}
			});
			return;
		},
		runHashChangeEvents:function(){
			var self = hashChangeController;
			var hash = self.getHash();
			for(var i=0;i<self.hashChangeEvents.length;i++){
				self.hashChangeEvents[i].fn.call(self.hashChangeEvents[i].parent,hash);
			}
			if(self.hashChangeEventsByHash[hash]){
				self.hashChangeEventsByHash[hash].fn.call(self.hashChangeEventsByHash[hash].parent,hash);
			}
			return;
		},
		getHash:function(){
			var ret_hash = '';
			if(location.search){
				var tmp_search = (location.search.replace('?','')).split('=');
				if(tmp_search[0] == '_escaped_fragment_'){
					ret_hash = '!'+tmp_search[1];
				}
			}
			if(!ret_hash){
				ret_hash = location.hash?(location.hash).replace('#',''):'';
			}
			return ret_hash;
		}
	};
	hashChangeController.init();

	// ポップアップ（要underscore.js）
	window.PopupController = {
		init_flg:false,
		tmpl_cashe:{},
		$bg:null,
		$popup:null,
		is_open:false,
		init:function(obj){
			if(!obj || !obj.popup_id || !obj.bg_id){return;}
			var that = this;
			this.init_flg = true;
			this.$bg = $('#'+obj.bg_id);
			this.$popup = $('#'+obj.popup_id);
			return false;
		},
		open:function(that){
			if(!this.init_flg){
				this.init();
			}
			// 対象要素がなければ何も処理しない
			if(!this.$bg.length || !this.$popup.length){return;}
			// ※act:trueが渡されたら常にポップアップ表示処理なので最初にポップアップクローズ処理をする
			if(that.act){
				this.close();
			}
			// thatで渡される値は以下の2パターンある。that.tmplがとれれば、(2)のパターン
			// 1) aタグで、data(…)で値を取得する
			// 2) オブジェクト
			if(!this.is_open){
				this.is_open = true;
				var args_obj = that.tmpl?(that.args||{}):(this.makeArgsObj($(that).data('args'))||{});
				var tmpl_id = that.tmpl?that.tmpl:$(that).data('tmpl');
				args_obj.link = that.tmpl?(that.link||''):$(that).attr('href');
				var tmpl;
				if(this.tmpl_cashe[tmpl_id]){
					tmpl = this.tmpl_cashe[tmpl_id];
				}else{
					if($('#'+tmpl_id).length){
						tmpl = this.tmpl_cashe[tmpl_id] =  _.template($('#'+tmpl_id).text());
					}else{
						console.error('指定のテンプレートがありません');
					}
				}

				// 各種サイズ・位置調整
				var window_height = window.innerHeight;
				var wrapper_height = $('#wrapper').outerHeight();
				var scrolltop = (document.documentElement.scrollTop || document.body.scrollTop);
				var bg_height = wrapper_height>window_height?wrapper_height:window_height;

				this.$bg.css({'height':bg_height+'px'}).show();
				this.$popup.html(tmpl(args_obj));

				var popup_height = this.$popup.outerHeight();
				var margin_top = (window_height - popup_height)/2;
				if(margin_top < 0){
					margin_top = 0;
				}
				if(scrolltop){
					margin_top += scrolltop;
				}
				// スクロール分足したらはみ出てしまう場合、一番下にそろえるのみ
				if(margin_top+popup_height > wrapper_height){
					margin_top = wrapper_height - popup_height;
				}
				this.$popup.css({'margin-top':margin_top+'px'}).show();
			}
			return false;
		},
		close:function(){
			if(this.is_open){
				this.is_open = false;
				this.$popup.hide().html('');
				this.$bg.hide();
			}
			return;
		},
		makeArgsObj:function(text){
			if(!text){return null;}
			var ret_obj = {};
			var ary1 = text.split('&&');
			var ary2;
			for(var i=0;i<ary1.length;i++){
				ary2 = ary1[i].split('==');
				ret_obj[ary2[0]] = ary2[1]?ary2[1]:'';
			}
			return ret_obj;
		}
	};
	
	// フルパネル（要underscore.js）
	window.FullpanelController = {
		is_disp:false,
		tmpl_cashe:{},
		fullpanel:null,
		toggle:null,
		pre_pos_top:0,
		pre_fullpanel_z:0,
		fullpanel_height:0,
		/**
		 * @methodOf fullpanelController 初期化
		 * @param obj.fullpanel_id フルパネル要素のID名
		 * @param obj.toggle_id フルパネル表示時に隠れるページ全体を囲む要素のID名(wrapper等)
		 */
		init:function(obj){
			if(!obj || !obj.toggle_id || !obj.fullpanel_id){return;}
			this.toggle = $('#'+obj.toggle_id);
			this.fullpanel = $('#'+obj.fullpanel_id);
			return;
		},
		/**
		 * @methodOf fullpanelController フルパネルを開く
		 * 2つのやり方でデータを受け取れるようにしてある
		 * ■Aタグのonclickで呼び出す
		 * @param obj クリックしたA要素（thisを指定すればよい）、Aタグのdataにtmpl と args（任意）が指定してある
		 * ■JavaScript内で処理を書く
		 * @param obj.tmpl テンプレートID
		 * @param obj.args{object} テンプレートに渡す値
		 */
		open:function(obj){
			// 対象要素がなければ何も処理しない
			if(!this.toggle.length || !this.fullpanel.length){return;}

			var that = this;
			if(!this.is_disp){
				this.is_disp = true;
				// tmpl_id は必ずある
				var tmpl_id = obj.tmpl?obj.tmpl:$(obj).data('tmpl');
				if(!tmpl_id){return false;}

				// tmplに渡す値
				var args = obj.tmpl?(obj.args||{}):(this.makeArgsObj($(obj).data('args'))||{});

				// tmpl用意
				if(!this.tmpl_cashe[tmpl_id]){
					this.tmpl_cashe[tmpl_id] = _.template($('#'+tmpl_id).text());
				}
				var tmpl = this.tmpl_cashe[tmpl_id];
				if(!tmpl){return false;}

				// 現在のスクロール位置をとっておく
				this.pre_pos_top = (document.documentElement.scrollTop || document.body.scrollTop);

				// fullpanelを画面外に配置してからソース埋め込み
				this.fullpanel.css({'display':'block','position':'absolute','top':this.pre_pos_top+window.innerHeight+'px','left':'0','width':'100%'});
				this.fullpanel.html(tmpl(args));

				// fullpanelのheightを計算（window,body,fullpanelの中で一番値が大きいもの
				this.fullpanel_height = function(){
					var max_height = window.innerHeight>$('body').outerHeight()?window.innerHeight:$('body').outerHeight();
					max_height = max_height>that.fullpanel.outerHeight()?max_height:that.fullpanel.outerHeight();
					return max_height;
				}();

				// fullpanel表示処理
				$('body').css({'min-height':this.fullpanel_height});
				this.fullpanel
					.css({'min-height':that.fullpanel_height,'height':'100%'})
					.animate({top:this.pre_pos_top},500,function(){
						// 隠れた要素を非表示
						that.toggle.hide();
						// fullpanel のスクロール位置を0に
						$(this).animate({top:0},0);
						window.scrollTo(0,0);

						// Ｚ値も保存しておく
						that.pre_fullpanel_z = $(this).css('z-index');

						// テキスト入力エリアが下にさがってしまうので…
						$(this).css({'position':'relative'});
						$(this).css({'min-height':0, 'z-index':0});
					});
				this.is_disp = true;
			}
			return;
		},
		/**
		 * @methodOf fullpanelController フルパネルを閉じる
		 */
		close:function(){
			var that = this;
			if(this.is_disp){
				// 隠れた要素を表示
				this.toggle.show();

				// 元のスクロール位置に移動
				$(window).scrollTop(this.pre_pos_top);
				this.fullpanel
					.css({'position':'absolute', 'z-index':this.pre_fullpanel_z, 'min-height':this.fullpanel_height})
					.animate({top:this.pre_pos_top},0)
					.animate({top:this.pre_pos_top+window.innerHeight},500,function(){
						// 画面外に出たら削除
						$(this).css({'display':'none','height':'auto'}).html();

						// 初期化
						$('body').css({'min-height':'auto'});
						that.fullpanel_height=0;
						that.pre_pos_top=0;
						that.pre_fullpanel_z=0;
						that.is_disp = false;
					});

			}
			return;
		},
		_isFirefox: function (ua) {
			ua = ua || window.navigator.userAgent;
			return (ua.match(/Firefox\//));
		},
		makeArgsObj:function(text){
			if(!text){return null;}
			var ret_obj = {};
			var ary1 = text.split('&&');
			var ary2;
			for(var i=0;i<ary1.length;i++){
				ary2 = ary1[i].split('==');
				ret_obj[ary2[0]] = ary2[1]?ary2[1]:'';
			}
			return ret_obj;
		}
	};

	// ポップアップとフルパネル切替を含めた機能（要underscore.js）
	window.DetailController = {
		bp:768,
		currentController:null,
		obj:null,
		open:function(obj){
			var current_bp = ResponseController.getCurrentBreakPoint();
			this.setController(current_bp);
			this.obj = obj;
			this.currentController.open(obj);
			return;
		},
		close:function(){
			this.currentController && this.currentController.close();
			this.currentController = null;
			this.obj = null;
			return;
		},
		reset:function(bp){
			// breakpointをまたいだときにはリセットする
			if(this.currentController){
				var controllerFromBp = bp >= this.bp ? PopupController : FullpanelController;
				if(this.currentController != controllerFromBp){
					this.close();
				}
			}
			return;
		},
		setController:function(current_bp){
			if(current_bp >= this.bp){
				this.currentController = PopupController;
			}else{
				this.currentController = FullpanelController;
			}
			return;
		}
	};
	// 背景クリックでクローズ
	window.bgController = {
		fn:[
			FullpanelController,PopupController,DetailController
		],
		close:function(){
			for(var i=0;i<this.fn.length;i++){
				this.fn[i].close();
			}
			return;
		},
		setEvent:function(fn){
			this.fn.push(fn);
			return;
		}
	};
	
	/*
	 * スムーススクロール
	 * @param {jqueryObject} クリックの対象を$('#hoge')で
	 * ある一定の距離以下の場合は距離に対してスピードを変更
	 */
	window.smoothScroll = function($target) {
		if ($target && $target.length) {
			var hrefPos = $target.offset().top,
				currentPos = 0,
				distance = 0,
				elmName = '',
				speed = 1000,
				userAgent = window.navigator.userAgent.toLowerCase();
			if ('scrollingElement' in document) {
				elmName = (document.scrollingElement.tagName).toLowerCase();
			}else if (userAgent.indexOf('msie') > -1 || userAgent.indexOf('trident') > -1 || userAgent.indexOf('firefox') > -1) {
				elmName = 'html';
			}else{
				elmName = 'body';
			}
			currentPos =$(elmName).scrollTop();
			distance = Math.abs(currentPos - hrefPos);
			if(distance<1333){
				speed = distance * 0.75;
			}
			$(elmName).animate({scrollTop : hrefPos}, speed);
		}
		return false;
	};

	/*
	 * ハッシュによるスムーススクロール（smoothScrollが定義されている前提）
	 * #_hoge のハッシュで $('#hoge')へスムーススクロールする
	 * @param なし
	 */
	var smoothScrollByHash = function(){
		var hash = location.hash?(location.hash).replace('#',''):'';
		if(hash && hash.match(/^_/)){
			smoothScroll($('#'+(hash.replace(/^_/,''))));
		}
	};
	hashChangeController.setEvent({fn:smoothScrollByHash,first:1000});

	/*
	 * スクロールで指定の要素が表示されたら指定の要素に.on を追加する。
	 * ページからの呼び出しは $('.hoge').addEffectByScroll() となります。
	 */
	var addEffectByScroll = {
		$tgts:[],
		viewportSize:null,
		viewportOffset:null,
		timer:null,
		set:function(tgt){
			var that = this;
			this.$tgts.push(tgt);

			if(!this.timer && this.$tgts.length){
				this.timer = setInterval(function(){that.checkInView.call(that);},250);
				$(window).on("scroll resize", function() {
						that.viewportSize = that.viewportOffset = null;
				});
			}
			return;
		},
		checkInView:function(){
			var left_add_element = false;
			this.viewportSize = this.viewportSize || getViewportSize();
			this.viewportOffset = this.viewportOffset || getViewportOffset();

			for(var i=0;i<this.$tgts.length;i++){
				var $element = this.$tgts[i];
				if($element.data('is_show')){
					continue;
				}
				left_add_element = true;

				var elementSize = { height: $element[0].offsetHeight, width: $element[0].offsetWidth };
				var elementOffset = $element.offset();
				if(elementOffset.top + elementSize.height > this.viewportOffset.top &&
						elementOffset.top < this.viewportOffset.top + this.viewportSize.height &&
						elementOffset.left + elementSize.width > this.viewportOffset.left &&
						elementOffset.left < this.viewportOffset.left + this.viewportSize.width) {
					$element.addClass('on').data('is_show',true);
				}
			}
			if(!left_add_element){
				clearInterval(this.timer);
				this.timer = null;
			}

			function getViewportOffset() {
				return {
					top:  window.pageYOffset || document.documentElement.scrollTop   || document.body.scrollTop,
					left: window.pageXOffset || document.documentElement.scrollLeft  || document.body.scrollLeft
				};
			}
			function getViewportSize() {
				return {height: window.innerHeight, width: window.innerWidth};
			}
			return;
		}
		
	};
	$.fn.addEffectByScroll = function() {
		return this.each(function(){
			var $this = $(this);
			if(!$this.length){return;}
			addEffectByScroll.set($this);
		});
	};

	/* ランキングコントローラー ベース */
	var BaseRankingController = function(){
		this.default_region = null;
		this.default_type=null;
		this.$tgt = null;
		this.$loading = null;
		this.$filter = null;
		this.$filter_btn = null;
		this.$last_update = null;
		this.loading_start_time = null;
		this.ranking_selected = {};
		this.filter_selected = {};
		this.api = {};
		this.tmpl = {};
		this.filter_params = []; // フィルター情報（動的に変わる場合）
		this.ranking_items = []; // ランキング項目情報
		this.page = 1;/* 今は1ページで固定 */
		this.lang = {}; // 表示用文字列
		this.ranking_list = []; // 整形後のランキング情報格納場所
		this.actionForRankingList = null; // ランキングリスト生成時の処理
		this.callbackLoadRankingData = null; // ランキング情報取得後の処理
		this.is_filter_loading = false; // フィルターパーツローディング中かどうかを保持
		this.is_ranking_loading = true; // ランキングパーツローディング中かどうかを保持

		/* セレクタ取得時に使用する情報 */
		this.option_parts_class = 'option-parts';
		this.ranking_table_id = 'resultstable';
		this.pinned_ranking_table_id = 'pinned-resultstable';
		this.ranking_last_update_p_class = 'last-updated';
		this.filter_parts_selector = '.filter';
		this.filter_btn_selector = 'p.btn a';
	};
	BaseRankingController.prototype.checkAndSetArgs = function(obj){
		var that = this;
		if(!obj || !obj.tgt_id || !obj.tmpl || !obj.lang || !obj.api || !obj.ranking_items){
			return false;
		}
		// 基本情報格納
        this.default_region = obj.default_region;
        this.default_type = (obj.default_type) ? obj.default_type : -1;
		this.$tgt = $('#'+obj.tgt_id);
		this.lang = obj.lang;
		this.api = obj.api;
		this.ranking_items = obj.ranking_items;

		// テンプレート保持
		_.each(obj.tmpl,function(tmpl){
			that.tmpl[tmpl.name] = _.template($('#tmpl-'+tmpl.id).html());
		});

		// テンプレート不足チェック
		if(!this.tmpl.loading){
			console.log('Loading Parts Missing');
			return false;
		}
		// ローディングを先にjQueryオブジェクト化
		this.$loading = $(this.tmpl.loading());

		return true;
	};
	// 必要な要素をつかんでおく
	BaseRankingController.prototype.setJqueryElements = function(){
		// フィルターエリアのパーツつかんでおく
		this.$filter = this.$tgt.find(this.filter_parts_selector);
		// フィルターボタンをつかむ
		this.$filter_btn = this.$filter.find(this.filter_btn_selector);
		// 最終更新日時パーツをつかむ
		this.$last_update = this.$tgt.find('.'+this.ranking_last_update_p_class);
	};
	// ローディングの開始時間をセットする
	BaseRankingController.prototype.setLoadingStartTime = function(){
		this.loading_start_time = new Date();
	};
	/* フィルターパラメータを取得してセットする */
	BaseRankingController.prototype.setFilterParams = function(){
		var that = this;
		this.$filter.find('select').each(function(){
			var $this = $(this);
			var name = $this.attr('name');
			if(name){
				var selected = $this.find('option:selected');
				var selected_value = selected.attr('value');
				that.filter_selected[name] = selected_value ? selected_value : '';
			}
		});
	};
	/* ランキング取得 */
	BaseRankingController.prototype.loadRankingData = function(){
		this.showLoading();
		this.is_ranking_loading = true;
		this.updateFilterBtn();
		var that = this;
		var data = {
			page:this.page,
			type:this.default_type
		};
		_.each(this.filter_selected,function(param_value,param_name){
			data[param_name] = param_value;
		});
		$.ajax({
			type:"get",
			url:this.api.getRanking,
			data:data,
			success:function(data){
				if(data.status == 503){
					that.drawStatus(data.status);
				}else{
					// ランキングのパラメータも更新する
					that.ranking_selected = _.mapObject(that.ranking_selected, function(val, key){
						return that.filter_selected[key] || val;
					});
					that.hideLoading(
						function(){
							that.is_ranking_loading = false;
							that.updateFilterBtn();
							that.setRankingList(data);
							that.updateRankingParts();
							that.callbackLoadRankingData && that.callbackLoadRankingData();
						}
					);
				}
			}
		});
	};
	/* ランキングリストを整形してセット */
	BaseRankingController.prototype.setRankingList = function(data){
		this.ranking_list = data.data.ranking_list;
		if(this.actionForRankingList){
			_.each(this.ranking_list,this.actionForRankingList);
		}
		this.ranking_last_update = region && region=='jp' ? data.data.info.lastUpdate_jst : data.data.info.lastUpdate_utc;
	};
	/* ランキングパーツ埋め込み */
	BaseRankingController.prototype.updateRankingParts = function(){
		$('#'+this.ranking_table_id).find('tbody').empty().append(this.tmpl.ranking_list({list:this.ranking_list,kind:'',ranking_items:this.ranking_items}));
		if($('#'+this.pinned_ranking_table_id).length){
			$('#'+this.pinned_ranking_table_id).find('tbody').empty().append(this.tmpl.ranking_list({list:this.ranking_list,kind:'only_rank',ranking_items:this.ranking_items}));
		}
		// 更新日更新
		if(this.$last_update){
			this.$last_update.empty().append(this.tmpl.ranking_update({ranking_last_update:this.ranking_last_update}));
		}
	};
	/* 絞込みボタンクリック時のイベント */
	BaseRankingController.prototype.onClickFilterBtn = function(e,that){
		e.preventDefault();
		if($(e.currentTarget).hasClass('na')){
			return;
		}
		that.setFilterParams();
		that.loadRankingData();
	};
	/* 絞込みボタン、有効/無効切替 */
	BaseRankingController.prototype.updateFilterBtn = function(){
		var is_filter_btn_enable = false;
		if(!this.is_filter_loading && !this.is_ranking_loading){
			is_filter_btn_enable = true;
		}
		if(is_filter_btn_enable){
			this.$filter_btn.removeClass('na');
		}else{
			this.$filter_btn.addClass('na');
		}
	};

	/* ローディング表示 */
	BaseRankingController.prototype.showLoading = function(){
		this.setLoadingStartTime();
		this.$loading.show();
		return;
	};
	/* ローディング非表示 */
	BaseRankingController.prototype.hideLoading = function(callback){
		var that = this;
		var loading_animation_time = 1800;
		var diff = (new Date()).getTime() - this.loading_start_time.getTime();
		if(diff>=loading_animation_time){
			callback && callback();
			this.$loading.hide();
		}else{
			setTimeout(function(){
				callback && callback();
				that.$loading.hide();
			},loading_animation_time - diff)
		}
		return;
	};
	/* データが取得できないときの表示処理 */
	BaseRankingController.prototype.drawStatus = function(code){
		var that = this;
		// フィルターをすべて無効表示
		this.$filter.find('select').empty().append('<option>--</option>');
		// ラベル用P リセット
		this.$filter.find('.'+this.option_parts_class).setLabelOfSelectBox('reset');
		// ランキングエリアにメンテナンス中メッセージ
		that.hideLoading(
			function(){
				$('#'+that.ranking_table_id).find('tbody').empty().append(that.tmpl.ranking_list_msg({code:code,kind:'',ranking_items:that.ranking_items}));
				if($('#'+that.pinned_ranking_table_id).length){
					$('#'+that.pinned_ranking_table_id).find('tbody').empty().append(that.tmpl.ranking_list_msg({code:code,kind:'only_rank',ranking_items:that.ranking_items}));
				}
			});
		return;
	};
	/* 通常のランキング */
	var RankingController = function(obj){
		BaseRankingController.call(this,obj);
		this.round_data = {};
		this.init(obj);
	};
	RankingController.prototype = new BaseRankingController();
	RankingController.prototype.init = function(obj){
		var that = this;
		if(!this.checkAndSetArgs(obj)){
			return;
		}
		// パラメータ追加セット
		this.filter_params = obj.filter_params||[];
		// ランキングデータ JSでの追加情報整形
		this.actionForRankingList = function(ranking){
			ranking.goals = ranking.goals_won - ranking.goals_lost;
		};

		// 初期表示
		this.drawBase();

		// イベントセット
		this.setEvent();

		// 現在のパラメータをセット
		this.setFilterParams();

		// ラウンド情報取得
		this.loadRegionData(this.default_region, this.default_type, function(){
			that.loadRankingData();
		});
	};
	RankingController.prototype.drawBase = function(obj){
		var that = this;
		// フィルターパーツ
		this.$tgt.append(this.tmpl.filter({filter_params:this.filter_params}));
		// ランキングパーツ
		this.$tgt.append(this.tmpl.ranking({ranking_items:this.ranking_items}));
		// ローディングパーツ
		this.$tgt.find('.result').append(this.$loading);

		// パーツをつかんでおく
		this.setJqueryElements();

		// ローディング開始時間セット
		this.setLoadingStartTime();
	};
	RankingController.prototype.setEvent = function(obj){
		var that = this;

		// ラベル用P
		this.$filter.find('.'+this.option_parts_class).setLabelOfSelectBox();

		// リージョン切替
		this.$filter.find('select[name=region]').change(function(){
			var selected = $(this).val();
			if(selected && that.filter_selected.region != selected){
				that.is_filter_loading = true;
				that.updateFilterBtn();
				that.loadingFilterParts();
				that.loadRegionData(selected, that.default_type, function(){
					that.filter_selected.region = selected;
				});
			}
		});

		// リージョン以外の切替
		this.$filter.find('select[name!=region]').change(function(){
			var selected = $(this).val();
			var filter_name = $(this).attr('name');
			var index_of_filter_params = -1;
			var tgt_list = that.round_data[that.filter_selected.region];
			_.each(that.filter_params,function(filter,index){
				if(filter_name == filter.name){
					// 変更したパラメータの値を保持
					index_of_filter_params = index;
					that.filter_selected[filter_name] = selected;
				}
				// 変更したパラメータの下層は初期化
				if(index_of_filter_params >= 0){
					if(index > index_of_filter_params){
						that.filter_selected[filter.name] = _.min(_.keys(tgt_list)) || 1;
					}
				}
				tgt_list = tgt_list[that.filter_selected[filter.name]];
			});
			// 変更対象があればフィルターパーツを更新
			if(index_of_filter_params >= 0){
				that.is_filter_loading = true;
				that.updateFilterBtn();
				that.loadingFilterParts({
					level:index_of_filter_params+1*1,
					callback:function(){
						that.updateFilterParts({region:that.filter_selected.region,level:(index_of_filter_params+1*1)});
					}
				});

			}
		});

		// 絞込みボタン
		this.$filter_btn.click(function(e){that.onClickFilterBtn(e,that);});

		return;
	};
	// フィルター情報読み込み
	RankingController.prototype.loadRegionData = function(region, type, callback){
		var that = this;
		$.ajax({
			type:"get",
			url:this.api.getFilterParams,
			data:{
				region:region,
				type:type
			},
			success:function(data){
				if(data.status == 503){
					that.drawStatus(data.status);
				}else{
					that.setRoundData(data);
					that.updateFilterParts({region:data.data.region});
					callback && callback(data);
				}
			}
		});
	};
	// リージョン単位でラウンドデータを整形する
	RankingController.prototype.setRoundData = function(data){
		var that = this;
		var region = that.filter_selected.region = data.data.region;
		if(!this.round_data[region]){
			this.round_data[region] = {};
		}
		var filter_num = that.filter_params.length;
		var round_list = data.data.round;
		if(!round_list.length){
			console.log('No Data');
		}
		_.each(round_list,function(val,index){
			// 現在選択されるべき＝開催中で一番新しいもの
			if (index == 0 || val.status == 2) {
				_.each(that.filter_params,function(param){
					that.filter_selected[param.name] = val[param.name];
				});
			}
			var filter_val_tmp = [];
			_.each(that.filter_params,function(filter_param,key){
				filter_val_tmp.push(val[filter_param.name]);
			});
			var current_level_obj = that.round_data[region];
			for(var i=0;i<filter_num;i++){
				if (!current_level_obj[filter_val_tmp[i]]){
					current_level_obj[filter_val_tmp[i]] = (i==filter_num-1)?[]:{};
				}
				if(i==filter_num-1){
					current_level_obj[filter_val_tmp[i]].push(val)
				}else{
					current_level_obj = current_level_obj[filter_val_tmp[i]];
				}
			}
		});
	};
	/* フィルターパーツ ローディング中 */
	RankingController.prototype.loadingFilterParts = function(obj){
		var that = this;
		if(!obj){
			obj = {};
		}
		if(!obj.level){
			obj.level = 0;
		}
		var tgt_filters = this.filter_params.slice(obj.level);
		_.each(tgt_filters,function(filter){
			var option_src = '<option>loading..</option>'
			that.$filter.find('select[name='+filter.name+']').empty().append(option_src).closest('.'+that.option_parts_class).setLabelOfSelectBox('reset');
		});
		if(obj.callback){
			if(this.filter_params.length > 2 && this.filter_params.length != obj.level){
				setTimeout(obj.callback,500);
			}else{
				obj.callback();
			}
		}
		return;
	};
	/* フィルターパーツ更新 */
	RankingController.prototype.updateFilterParts = function(obj){
		var that = this;
		if(!obj){
			obj = {};
		}
		var level = obj.level || 0;
		var region = obj.region || this.filter_selected.region;

		var tgt_list = this.round_data[region];
		_.each(this.filter_params,function(filter_param,index){
			if(index >= level){
				var option_src = that.makeFilterOptionSrc(tgt_list,filter_param.name,that.filter_selected[filter_param.name]);
				that.$filter.find('select[name='+filter_param.name+']').empty().append(option_src);
			}
			tgt_list = tgt_list[that.filter_selected[filter_param.name]];
		});

		// ラベル用P
		this.$filter.find('.'+this.option_parts_class).setLabelOfSelectBox('reset');

		// 絞込みボタンを有効に
		this.is_filter_loading = false;
		this.updateFilterBtn();

		return;
	};
	/* フィルター option ソース生成 */
	RankingController.prototype.makeFilterOptionSrc = function(tgt_list,name,current){
		var that = this;
		var options = [];
		_.each(tgt_list,function(val,key){
			options.push({val:key,disp_name:that.lang[name+key]});
		});
		return this.tmpl.filter_option({options:options,current:current});
	};


	/* スタッツランキング */
	var StatsRankingController = function(obj){
		BaseRankingController.call(this,obj);
		this.init(obj);
	}
	StatsRankingController.prototype = new BaseRankingController();
	StatsRankingController.prototype.init = function(obj){
		var that = this;
		if(!this.checkAndSetArgs(obj)){
			return;
		}
		// ランキングデータ取得後の処理
		this.callbackLoadRankingData = function(){
			that.changeRankingThLable();
		};

		// 初期表示
		this.drawBase();

		// イベントセット
		this.setEvent();

		// 現在のパラメータをセット
		this.setFilterParams();

		// ランキング情報取得
		this.loadRankingData();
	};
	StatsRankingController.prototype.drawBase = function(obj){
		var that = this;
		// フィルターパーツ
		this.$tgt.append(this.tmpl.filter());
		// ランキングパーツ
		this.$tgt.append(this.tmpl.ranking({ranking_items:this.ranking_items}));
		// ローディングパーツ
		this.$tgt.find('.result').append(this.$loading);

		// パーツをつかんでおく
		this.setJqueryElements();

		// ローディング開始時間セット
		this.setLoadingStartTime();
	};
	StatsRankingController.prototype.setEvent = function(obj){
		var that = this;

		// ラベル用P
		this.$filter.find('.'+this.option_parts_class).setLabelOfSelectBox();

		// 絞込みボタン
		this.$filter_btn.click(function(e){that.onClickFilterBtn(e,that);});
	};
	StatsRankingController.prototype.changeRankingThLable = function(){
		console.log(this);
		var $tgt_td = $('#'+this.ranking_table_id).find('thead td.score');
		var label = this.lang['type'+this.filter_selected.type] || '';
		if(label){
			$tgt_td.text(this.lang['type'+this.filter_selected.type]);
		}
	};


	/**
	 * セレクトメニューとラベル要素の連動、jqueryプラグインとして使用想定
	 * @param obj
	 *   obj.tgt_elm       : jQueryオブジェクト（必須、jQueryプラグインから必ず渡される）
	 *   obj.select_exp    : tgt_elm 内の select要素 のセレクタ文字列（任意）
	 *   obj.select_p_exp  : tgt_elm 内の セレクトされている内容の表示用要素のセレクタ文字列（任意）
	 *   obj.changeCallback: セレクト変更時のコールバック関数（任意、デフォルトはnull）
	 *                       parent を指定したい場合は {fn:コールバック関数,parent:親} という形で渡す
	 *   obj.is_exec_change_callback_at_init @type {boolean}
	 *                     : changeCallback が指定されている場合、初期化時にも処理するか否か（任意、デフォルトはfalse）
	 * @constructor
	 */
	var SetLabelOfSelectBox = function(obj){
		if(!obj || !obj.tgt_elm) return;
		this.tgt_elm = obj.tgt_elm;
		// セレクト
		this.tgt_select = this.tgt_elm.find(obj.select_exp || 'select');
		// セレクトされている内容の表示用
		this.tgt_select_p = obj.select_p_exp?this.tgt_elm.find(obj.select_p_exp):this.tgt_select.prev('p');
		// セレクト変更後のコールバック
		this.changeCallback = obj.changeCallback || null;
		// セレクト変更後のコールバックをinit時にも処理するか
		this.is_exec_change_callback_at_init = obj.is_exec_change_callback_at_init || false;
		// セレクトされている要素
		this.current_select = null;
		if(this.tgt_select.length){
			this.init();
		}
	};
	SetLabelOfSelectBox.prototype.init = function(){
		var that = this;
		// 初期処理
		this.current_select = this.tgt_select.find('option:selected');
		this.setLabel();
		if(this.is_exec_change_callback_at_init){
			this.onChangeEvent();
		}
		// プルダウン変更時処理
		this.tgt_select.change(function(){
			that.current_select = $(this).find('option:selected');
			that.setLabel();
			that.onChangeEvent();
			return;
		});
	};
	SetLabelOfSelectBox.prototype.setLabel=function(){
		this.tgt_select_p.text(this.current_select.text());
		return;
	};
	SetLabelOfSelectBox.prototype.onChangeEvent=function(){
		var that = this;
		if(this.changeCallback){
			if(typeof(this.changeCallback) == "function"){
				this.changeCallback(this.current_select);
			}else if(typeof(this.changeCallback.fn) == "function"){
				var parent = this.changeCallback.parent || this;
				var params = this.changeCallback.params || {};
				this.changeCallback.fn.call(parent,this.current_select,params);
			}
		}
	};
	SetLabelOfSelectBox.prototype.reset = function(){
		this.current_select = this.tgt_select.find('option:selected');
		this.setLabel();
	};
	$.fn.setLabelOfSelectBox = function(op) {
		if(!op){
			op = {};
		}
		return this.each(function(){
			var $this = $(this);
			if(!$this.length){return;}
			if($(this).data('setLabelOfSelectBox') && op == 'reset'){
				$(this).data('setLabelOfSelectBox').reset();
			}else{
				op.tgt_elm = $this;
				$(this).data('setLabelOfSelectBox',new SetLabelOfSelectBox(op));
			}
		});


	};
	window.RankingController = RankingController;
	window.StatsRankingController = StatsRankingController;

	var globalMenuController = {
		$nav:null,
		menu:{},
		init:function(obj){
			if(!obj || !obj.expr){
				return;
			}
			var that = this;
			var $nav = $(obj.expr);
			if($nav.length){
				this.$nav= $nav;
				this.$nav.find('p').each(function(){
					var $p = $(this);
					var p_id = $p.attr('id');
					var $ul = $p.next('ul');
					if($ul.length && p_id){
						that.menu[p_id] = {
							$p:$p,
							$ul:$ul
						}
						$p.click(function(){
							that.onMenuClick.call(that,p_id);
							return false;
						});
					}
				});
			}
		},
		onMenuClick:function(p_id){
			$click_p = this.menu[p_id].$p;
			if($click_p.hasClass('open')){
				$click_p.removeClass('open');
				this.menu[p_id].$ul.slideUp('normal');
			}else{
				for(var i in this.menu){
					if(i != p_id){
						this.menu[i].$p.removeClass('open');
						this.menu[i].$ul.slideUp('fast');
					}
				}
				$click_p.addClass('open');
				this.menu[p_id].$ul.slideDown('normal');
			}

		}
	};
	window.globalMenuController = globalMenuController;

	/*
	 * ページトップへのボタンの表示を制御
	 * @param {string} ボタンのIDを＃つきで
	 */
	var pagetopController = function(target_id){
		if (!target_id) return;
		var $target = $(target_id);
		var is_visible = false;
		// ボタンの表示を制御
		$(window).scroll(function(e) {
			var _scroll = $(this).scrollTop();
			if(_scroll == 0 && is_visible){
				$target.removeClass('show');
				is_visible = false;
			}else if(!is_visible){
				$target.addClass('show');
				is_visible = true;
			}
		});
	};
	/* pagetopController('#page-top'); */

    /**
     * 年切り替えで遷移するURLを取得
     * @param to_year {number}
     * @param from  {object} year,region,lang ※yearは現在未使用だが、取得しておく
     */
    var getUrlOfMove = function (to_year, from) {
        // リージョンと言語の組み合わせ、from:to
        var default_setting = {
            2017: {
                'us_en-us': 'eu_en',
                'us_fr-ca': 'eu_en',
                'us_es-mx': 'eu_en',
                'us_pt-br': 'eu_en',
                'eu_en': 'eu_en',
                'eu_fr': 'eu_en',
                'eu_de': 'eu_en',
                'eu_it': 'eu_en',
                'eu_es': 'eu_en',
                'eu_pt': 'eu_en',
                'eu_ar': 'eu_en',
                'jp_ja': 'jp_ja',
                'as_en-sg': 'eu_en',
                'as_zh-cn': 'eu_en',
                'as_zh-tw': 'eu_en',
                'as_ko': 'eu_en'
            },
            2018: {
                'us_en-us': 'us_en-us',
                'us_fr-ca': 'us_fr-ca',
                'us_es-mx': 'us_es-mx',
                'us_pt-br': 'us_pt-br',
                'eu_en': 'eu_en',
                'eu_fr': 'eu_fr',
                'eu_de': 'eu_de',
                'eu_it': 'eu_it',
                'eu_es': 'eu_es',
                'eu_pt': 'eu_pt',
                'eu_ar': 'eu_ar',
                'jp_ja': 'jp_ja',
                'as_en-sg': 'as_en-sg',
                'as_zh-cn': 'as_zh-cn',
                'as_zh-tw': 'as_zh-tw',
                'as_ko': 'as_ko'
            }
        };
        if (!to_year || !from.region || !from.lang) {
            console.log('変更後の年度、現在のregion,lang指定は必須');
            return;
        }
        var tmp = default_setting[to_year][from.region + '_' + from.lang].split('_'),
                region = tmp[0],
                lang = tmp[1];
        if (!region || !lang) {
            console.log('該当するregionとlangの組み合わせがない');
            return;
        }
        if (to_year == 2017) {
            return '/' + to_year + '/' + lang + '/';
        } else {
            return '/' + to_year + '/' + region + '/' + lang + '/';
        }
    };
    window.getUrlOfMove=getUrlOfMove;

    /*タブ切り替え*/
    var tabChangeController = {
        class_name: 'current',
        current: '',
        hash_prefix: '',
        tabs: [],
        tab_el: '',
        content_el: '',
        params: {},
        init: function (obj) {
            var obj = obj || {};
            for (var key in obj) {
                this[key] = obj[key];
            }
            // タブとタブ要素、コンテンツ要素の指定は必須
            if (!this.tabs.length || !this.tab_el || !this.content_el) {
                console.error('必須項目が不足しています');
                return false;
            }
            // クラスの付け替えを実行
            this.toggleClass(this.current);
        },
        toggleClass: function (hash) {
            var tgt = [this.tab_el, this.content_el];
            this.current = this._getCurrent(hash);
            for (var i = 0; i < tgt.length; i++) {
                $(tgt[i]).removeClass(this.class_name);
                $(tgt[i] + '.' + this.current).addClass(this.class_name);
            }
        },
        _getCurrent: function (hash) {
            var _current = hash.replace(this.hash_prefix, '');
            if (!_current || !this._hasClass(_current)) {
                // デフォルト表示を指定
                _current = this.tabs[0];
            }
            return _current;
        },
        _hasClass: function (hash) {
            for (var i = 0; i < this.tabs.length; i++) {
                if (hash == this.tabs[i]) return true;
            }
            return false;
        }
    };
    window.tabChangeController=tabChangeController;

}).call(this, jQuery, _);