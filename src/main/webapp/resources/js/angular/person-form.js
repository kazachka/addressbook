(function(angular) {
    angular.PersonForm = PersonForm;

    function PersonForm(id, name, address, phone, email) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;

        this.copyFrom = function(personForm) {
            this.id = personForm.id;
            this.name = personForm.name;
            this.address = personForm.address;
            this.phone = personForm.phone;
            this.email = personForm.email;
        }

        this.clear = function() {
            this.id = 0;
            this.name = "";
            this.address = "";
            this.phone = "";
            this.email = "";
        }

    }

})(window.angular || (window.angular = {}));
