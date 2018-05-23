angular.module('appForm')
.config [
  '$stateProvider'
  '$urlRouterProvider'
  ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/dashboard'

    $stateProvider
    #== Application Routes =====================================================
    .state 'app', {
      abstract: true
      templateUrl: 'app/layout.html'
    }

      .state 'app.main', {
        abstract: true
        controller: 'AppMainController'
        templateUrl: 'app/main/layout.html'
        resolve: {
          auth: ($auth, $state) -> $auth.validateUser().catch ->
            $state.go 'signin.index'
        }
      }

        #/dashboard
        .state 'app.main.dashboard', {
          controller: 'DashboardController'
          templateUrl: 'app/main/dashboard/index.html'
          title: 'Dashboard'
          url: '/dashboard'
        }
      #detail
      .state 'detail', {
        controller: 'PropertyDetailController'
        templateUrl: 'app/main/dashboard/detail.html'
        title: 'Detail'
        url: '/detail/:id'
      }

    #------- error pages -------------------------------------------------------
      .state 'app.errors', {
        abstract: true
        templateUrl: 'app/errors/layout.html'
      }

        #/403
        .state 'app.errors.forbidden', {
          templateUrl: 'app/errors/forbidden.html'
          title: 'Forbidden'
          url: '/403'
        }

        #/404
        .state 'app.errors.notFound', {
          templateUrl: 'app/errors/not_found.html'
          title: 'Not Found'
          url: '/404'
        }

        #/coming_soon
        .state 'app.errors.comingSoon', {
          templateUrl: 'app/errors/coming_soon.html'
          title: 'Coming Soon'
          url: '/coming_soon'
        }

    #== Application Form Routes ================================================
    .state 'apply', {
      abstract: true
      templateUrl: 'apply/layout.html'
      resolve: {
        auth: ($auth, $state) -> $auth.validateUser().catch ->
          $state.go 'signin.index'
      }
    }

      #/apply/:listingId
      .state 'apply.form', {
        controller: 'ApplicationsController'
        templateUrl: 'apply/form.html'
        url: '/apply/:listingId'
      }

      #/apply/success
      .state 'apply.success', {
        controller: 'ApplySuccessController'
        templateUrl: 'apply/success.html'
        url: '/apply-success'
      }

    #== Signin Routes ==========================================================
    .state 'signin', {
      abstract: true
      templateUrl: 'signin/layout.html'
    }

      #/signin
      .state 'signin.index', {
        controller: 'SigninController'
        templateUrl: 'signin/index.html'
        title: 'Sign In'
        url: '/signin'
      }

      #/signin/forgot
      .state 'signin.forgot', {
        templateUrl: 'signin/forgot.html'
        title: 'Forgot Your Password?'
        url: '/signin/forgot'
      }
]
