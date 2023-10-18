@extends('voyager::master')

@section('css')
    <style>
        .table tbody td > img{
            max-height: 46px;
        }
    </style>
@stop

@section('page_header')
    <div class="container-fluid">
        <h1 class="page-title">
            <i class="{{ $dataType->icon }}"></i> {{ $dataType->display_name_plural }}
        </h1>
        @can('add',app($dataType->model_name))
            <a href="{{ route('voyager.'.$dataType->slug.'.create') }}" class="btn btn-success btn-add-new">
                <i class="voyager-plus"></i> <span>{{ __('voyager::generic.add_new') }}</span>
            </a>
        @endcan
        @can('delete',app($dataType->model_name))
            @include('voyager::partials.bulk-delete')
        @endcan
        @can('edit',app($dataType->model_name))
            @if(isset($dataType->order_column) && isset($dataType->order_display_column))
                <a href="{{ route('voyager.'.$dataType->slug.'.order') }}" class="btn btn-primary">
                    <i class="voyager-list"></i> <span>{{ __('voyager::bread.order') }}</span>
                </a>
            @endif
        @endcan
        @include('voyager::multilingual.language-selector')
    </div>
@stop

@section('page_header')
    <h1 class="page-title">
        <i class="voyager-bar-chart"></i> Events
    </h1>
@stop

@section('content')
    <div class="container-fluid">
        @include('voyager::alerts')
    </div>

    <div class="page-content container-fluid">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-bordered">
                    <div class="panel-body">
                        <table id="dataTable" class="table table-hover">
                            <thead>
                            <tr>
                                <th>Id</th>
                                <th>Player 1</th>
                                <th>Result</th>
                                <th>Player 2</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop

@section('javascript')
    <script type="application/javascript">
        $(function() {
            $('#dataTable').DataTable({
                processing: true,
                serverSide: true,
                ajax: '{!! route('voyager.event.pagination') !!}',
                columns: [
                    {data: 'id', name: 'id'},
                    {data: 'player_1', name: 'player_1',
                        render: function ( data, type, full, meta ) {
                            return '<a href="/admin/players/'+ data.id +'" class="btn">'+ data.name +'</a>';
                        }},
                    {data: 'result', name: 'result'},
                    {data: 'player_2', name: 'player_2',
                        render: function ( data, type, full, meta ) {
                            return '<a href="/admin/players/'+ data.id +'" class="btn">'+ data.name +'</a>';
                        }},
                    {data: 'created_at', name: 'created_at'},
                    {data: 'action', name: 'action', orderable: false, searchable: false},
                ]
            });
        });
    </script>
@stop
