import Ember from 'ember';

export default Ember.Mixin.create({
  actions: {
    save: function() {
      const success = () => this.transitionTo('users');

      this
        .currentModel
        .save()
        .then(success);
    }
  },

  deactivate: function() {
    if (this.currentModel.get('isNew')) {
      this.currentModel.deleteRecord();
    } else {
      this.currentModel.rollbackAttributes();
    }
  }
});
