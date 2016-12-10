<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE HTML/>

<html>
    <head>
        <title>Address Book</title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <link rel="stylesheet" href="resources/lib/bootstrap/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="resources/css/styles.css"/>
        <script src="resources/lib/jquery/jquery.min.js"></script>
        <script src="resources/lib/bootstrap/js/bootstrap.js"></script>
        <script src="resources/lib/angularjs/angular.min.js"></script>
        <script src="resources/js/jquery/modals.js"></script>
        <script src="resources/js/angular/person-form.js"></script>
        <script src="resources/js/angular/person-form-ctrl.js"></script>
        <script src="resources/js/angular/app.js"></script>
    </head>
    <body ng-app="addressBook" ng-controller="PersonFormCtrl" ng-init="onSearchSubmit();">
        <nav class="navbar-static-top navbar-inverse">
            <div class="form-group pull-left">
                <input type="button" value="+" data-toggle="modal" data-target="#add"
                         ng-click="cancelUpdate();" class="btn btn-primary"/>
            </div>
            <div>
                <form id="searchForm" name="searchForm" ng-submit="onSearchSubmit();"
                        class="form-inline">
                    <input type="hidden" id="searchModel.id" name="id"
                            ng-model="searchModel.id"/>
                    <input type="text" id="searchModel.name" name="name"
                            placeholder="Name" ng-model="searchModel.name" class="form-control form-group"/>
                    <input type="text" id="searchModel.address" name="address"
                            placeholder="Address" ng-model="searchModel.address" class="form-control form-group"/>
                    <input type="text" id="searchModel.phone" name="phone"
                            placeholder="Phone" ng-model="searchModel.phone" class="form-control form-group"/>
                    <input type="text" id="searchModel.email" name="email"
                            placeholder="E-Mail" ng-model="searchModel.email" class="form-control form-group"/>
                    <button type="submit" class="btn btn-primary form-control"/>
                        <span class="glyphicon glyphicon-search" aria-hidden="true"/>
                    </button>
                </form>
            </div>
        </nav>
        <div class="container-fluid">
            <table ng-show="addressList != 0" class="table table-hover">
                <thead>
                    <th>Name</th>
                    <th>Address</th>
                    <th>Phone</th>
                    <th>E-Mail</th>
                    <th></th>
                </thead>
                <tr ng-repeat="person in addressList">
                    <td ng-bind="person.name"></td>
                    <td ng-bind="person.address"></td>
                    <td ng-bind="person.phone"></td>
                    <td ng-bind="person.email"></td>
                    <td>
                        <a href="#" ng-click="startUpdate(person);">
                            <span class="glyphicon glyphicon-pencil"/>
                        </a>
                        <a href="#" ng-click="showModal(remove, person);">
                            <span class="glyphicon glyphicon-remove"/>
                        </a>
                     </td>
                </tr>
            </table>
            <div ng-show="addressList == 0" class="row">
                <p class="lead text-center">
                    No entries.
                </p>
            </div>
        </div>
        <div id="add" class="modal fade" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="row">
                            <form id="addForm" name="addForm">
                                <input type="hidden" id="addModel.id" name="id"
                                        ng-model="addModel.id"/>
                                <div class="form-group">
                                    <label for="name">Name</label>
                                    <input type="text" id="addModel.name" name="name"
                                            required ng-model="addModel.name"
                                            class="form-control"/>
                                    <div class="alert alert-danger" 
                                            ng-show="addModel.name === undefined"
                                            role="alert">
                                        Shouldn&apos;t be empty.
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="addModel.address">Address</label>
                                    <input type="text" id="addModel.address" name="address"
                                            ng-model="addModel.address" class="form-control"/>
                                </div>
                                <div class="form-group">
                                    <label for="addModel.phone">Phone</label>
                                    <input type="text" id="addModel.phone" name="phone"
                                            ng-model="addModel.phone"
                                            ng-pattern="/^\+\d{11,13}$/" class="form-control">
                                    <div ng-show="addModel.phone === undefined" role="alert" 
                                            class="alert alert-danger">
                                        Should starts with + and has 11-13 digits.
                                    </div>
                                </div>
                                <div class="form-group"/>
                                    <label for="addModel.email">E-Mail</label>
                                    <input type="email" id="addModel.email" name="email"
                                            ng-model="addModel.email" class="form-control"/>
                                    <div ng-show="addModel.email === undefined" role="alert" 
                                            class="alert alert-danger">
                                        Should be valid e-mail address.
                                    </div>
                                </div>
                                <div class="pull-left">
                                    <input type="button" value="Cancel"
                                            ng-click="cancelUpdate();"
                                            data-dismiss="modal"
                                            class="btn btn-default"/>
                                </div>
                                <div>
                                    <input type="submit" value="Submit"
                                            ng-disabled="addModel.name === undefined || addModel.name === ''
                                                            || addModel.phone === undefined || addModel.phone === ''
                                                            || addModel.email===undefined || addModel.email === ''"
                                            ng-click="onAddSubmit();"
                                            data-dismiss="modal"
                                            class="btn btn-primary"/>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="alert" class="modal fade" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <p>
                            Error occured. Please reload page.
                        </p>
                        <input type="button" class="btn btn-default"
                                data-dismiss="modal" value="Close"/>
                    </div>
                </div>
            </div>
        </div>
        <div id="deleteModal" class="modal fade" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <p>Are you sure?</p>
                        <input type="button" class="btn btn-default"
                                data-dismiss="modal" value="No"/>
                        <input id="modalYes" type="button" class="btn btn-default"
                                data-dismiss="modal" value="Yes"/>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

