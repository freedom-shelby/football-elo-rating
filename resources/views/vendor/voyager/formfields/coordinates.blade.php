<style>
    #map {
        height: 400px;
        width: 100%;
    }
</style>
@if($dataTypeContent->location->getLat() != null)
    <input type="hidden" name="{{ $row->field }}[lat]" value="{{ $dataTypeContent->location->getLat() }}" id="lat"/>
    <input type="hidden" name="{{ $row->field }}[lng]" value="{{ $dataTypeContent->location->getLng() }}" id="lng"/>
@else
    <input type="hidden" name="{{ $row->field }}[lat]" value="{{ config('voyager.googlemaps.center.lat') }}" id="lat"/>
    <input type="hidden" name="{{ $row->field }}[lng]" value="{{ config('voyager.googlemaps.center.lng') }}" id="lng"/>
@endif

<script type="application/javascript">
    function initMap() {
        @if($dataTypeContent->location->getLat() != null)
            var center = {lat: {{ $dataTypeContent->location->getLat() }}, lng: {{ $dataTypeContent->location->getLng() }}};
        @else
            var center = {lat: {{ config('voyager.googlemaps.center.lat') }}, lng: {{ config('voyager.googlemaps.center.lng') }}};
        @endif
        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: {{ config('voyager.googlemaps.zoom') }},
            center: center
        });
        var markers = [];
        @if($dataTypeContent->location->getLat() != null)
            var marker = new google.maps.Marker({
                    position: {lat: {{ $dataTypeContent->location->getLat() }}, lng: {{ $dataTypeContent->location->getLng() }}},
                    map: map,
                    draggable: true
                });
            markers.push(marker);
        @else
            var marker = new google.maps.Marker({
                    position: center,
                    map: map,
                    draggable: true
                });
        @endif

        google.maps.event.addListener(marker,'dragend',function(event) {
            document.getElementById('lat').value = this.position.lat();
            document.getElementById('lng').value = this.position.lng();
        });
    }
</script>
<div id="map"/>
<script async defer src="https://maps.googleapis.com/maps/api/js?key={{ config('voyager.googlemaps.key') }}&callback=initMap"></script>
