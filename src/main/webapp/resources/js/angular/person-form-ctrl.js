(function(angular) {
    angular.PersonFormCtrl = PersonFormCtrl;
    
    function PersonFormCtrl($scope, $http) {

        $scope.searchModel = new angular.PersonForm(0, "", "", "", "");
        $scope.addModel = new angular.PersonForm(0, "", "", "", "");
        $scope.addressList = [];
        $scope.isAdding = true;

        $scope.showModal = showModal;

        $scope.onSearchSubmit = function() {
            $http
                .post("/get",  JSON.stringify($scope.searchModel))
                .success(function(response) {
                    $scope.addressList = response;
                });
        }

        $scope.remove = function(person) {
            $http
                .delete("/delete/" + person.id)
                .success(function() {
                    $scope.addressList = $scope.addressList.filter(x => x.id !== person.id);
                })
                .error(function() {
                    showAlert();
                });
        }

        $scope.startUpdate = function(person) {
            $scope.cancelUpdate();
            $scope.addModel.copyFrom(person);
            $scope.isAdding = false;
            jQuery("#add").modal("show");
        }

        $scope.cancelUpdate = function() {
            $scope.addModel.clear();
            $scope.isAdding = true;
        }

        $scope.onAddSubmit = function() {
            var method;
            var path;
            if($scope.isAdding) {
                method = "POST";
                path = "/add";
            }
            else {
                method = "PUT";
                path = "/update";
            }
            $http({
                "method": method,
                "url": path,
                "data": JSON.stringify($scope.addModel)
            })
            .success(function() {
                $scope.addModel = new angular.PersonForm(0, "", "", "", "");
                $scope.onSearchSubmit();
                $scope.isAdding = false;
            })
            .error(function() {
                showAlert();
            });
        }

    }

})(window.angular || (window.angular = {}));
