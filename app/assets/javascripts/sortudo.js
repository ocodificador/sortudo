var app = angular.module('Sortudo', ['ngResource']);

app.factory("Player", [ "$resource",
	function($resource) {
   	return $resource("/players/:id", {
      id: "@id"
    	}, {
      update: {
        method: "PUT"
      },
			destroy: {
				method: "DELETE"
			}
    });
  }
]);


app.controller('SortudoCtrl', ['$scope', 'Player', function($scope, Player) {
	$scope.players = Player.query();
	
	$scope.addPlayer = function() {
	  var player = Player.save($scope.newPlayer);
	  $scope.players.push(player);
	  return $scope.newPlayer = {};
	};
	
	$scope.rollDice = function() {
		// ????
	};
	
	$scope.eraseAll = function() {
	  var player;
	  angular.forEach($scope.players, function(player) {
			player.$destroy();
	  });
		$scope.players = [];
	};
	

}]);
