import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import SaveModelMixin from '../../mixins/users/save-model-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, SaveModelMixin, {
  model: function() {
    return this.store.createRecord('user');
  }
});
