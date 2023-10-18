<footer class="app-footer">
    <div class="site-footer-right">
        @if (rand(1,100) == 100)
            <i class="voyager-rum-1"></i> {{ "Made with ArmSALArm and together with rum" }}
        @else
            Made by <a href="https://sunrisedvp.systems" target="_blank">Sunrise DVP</a>
        @endif
        @php $version = Voyager::getVersion(); @endphp
        @if (!empty($version))
            - {{ $version }}
        @endif
    </div>
</footer>
