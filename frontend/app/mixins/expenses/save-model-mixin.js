import Ember from 'ember';

export default Ember.Mixin.create({
  actions: {
    save: function() {
      this
        .currentModel
        .save()
        .then(() => {
          this.transitionTo('expenses');
        });
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
