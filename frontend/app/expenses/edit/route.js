import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import SaveModelMixin from '../../mixins/expenses/save-model-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, SaveModelMixin);
