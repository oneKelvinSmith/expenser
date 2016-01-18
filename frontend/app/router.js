import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('signup');
  this.route('login');
  this.route('users', function() {
    this.route('new');

    this.route('edit', {
      path: ':user_id/edit'
    });

    this.route('show', {
      path: ':user_id'
    });
  });
  this.route('expenses', function() {
    this.route('new');

    this.route('edit', {
      path: ':expense_id/edit'
    });

    this.route('show', {
      path: ':expense_id'
    });
  });
});

export default Router;
