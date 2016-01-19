/* globals moment */

import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service(),

  weekStart: moment().startOf('isoWeek').startOf('day'),
  weekEnd: moment().endOf('isoWeek').endOf('day'),

  expensesForWeek: Ember.computed('model.@each.datetime', 'weekStart', 'weekEnd', function() {
    const start = this.get('weekStart');
    const end = this.get('weekEnd');

    return this.get('model').filter(expense => {
      return moment(expense.get('datetime')).isBetween(start, end);
    });
  }),

  totalAmount: Ember.computed('expensesForWeek.@each.amount', function() {
    return this
      .get('expensesForWeek')
      .reduce((sum, expense) => sum + expense.get('amount'), 0);
  }),

  dailyAverage: Ember.computed('totalAmount', function() {
    return (this.get('totalAmount') / 7).toFixed(2);
  })
});
