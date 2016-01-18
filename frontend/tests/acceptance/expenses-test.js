import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from '../helpers/start-app';

var application;
var originalConfirm;
var confirmCalledWith;

module('Acceptance: Expense', {
  beforeEach: function() {
    application = startApp();
    originalConfirm = window.confirm;
    window.confirm = function() {
      confirmCalledWith = [].slice.call(arguments);
      return true;
    };
  },
  afterEach: function() {
    Ember.run(application, 'destroy');
    window.confirm = originalConfirm;
    confirmCalledWith = null;
  }
});

test('visiting /expenses without data', function(assert) {
  visit('/expenses');

  andThen(function() {
    assert.equal(currentPath(), 'expenses.index');
    assert.equal(find('#blankslate').text().trim(), 'No Expenses found');
  });
});

test('visiting /expenses with data', function(assert) {
  server.create('expense');
  visit('/expenses');

  andThen(function() {
    assert.equal(currentPath(), 'expenses.index');
    assert.equal(find('#blankslate').length, 0);
    assert.equal(find('table tbody tr').length, 1);
  });
});

test('create a new expense', function(assert) {
  visit('/expenses');
  click('a:contains(New Expense)');

  andThen(function() {
    assert.equal(currentPath(), 'expenses.new');

    fillIn('label:contains(Datetime) input', new Date());
    fillIn('label:contains(Description) input', 'MyString');
    fillIn('label:contains(Amount) input', 42);
    fillIn('label:contains(Comment) input', 'MyString');

    click('input:submit');
  });

  andThen(function() {
    assert.equal(find('#blankslate').length, 0);
    assert.equal(find('table tbody tr').length, 1);
  });
});

test('update an existing expense', function(assert) {
  server.create('expense');
  visit('/expenses');
  click('a:contains(Edit)');

  andThen(function() {
    assert.equal(currentPath(), 'expenses.edit');

    fillIn('label:contains(Datetime) input', new Date());
    fillIn('label:contains(Description) input', 'MyString');
    fillIn('label:contains(Amount) input', 42);
    fillIn('label:contains(Comment) input', 'MyString');

    click('input:submit');
  });

  andThen(function() {
    assert.equal(find('#blankslate').length, 0);
    assert.equal(find('table tbody tr').length, 1);
  });
});

test('show an existing expense', function(assert) {
  server.create('expense');
  visit('/expenses');
  click('a:contains(Show)');

  andThen(function() {
    assert.equal(currentPath(), 'expenses.show');

    assert.equal(find('p strong:contains(Datetime:)').next().text(), new Date());
    assert.equal(find('p strong:contains(Description:)').next().text(), 'MyString');
    assert.equal(find('p strong:contains(Amount:)').next().text(), 42);
    assert.equal(find('p strong:contains(Comment:)').next().text(), 'MyString');
  });
});

test('delete a expense', function(assert) {
  server.create('expense');
  visit('/expenses');
  click('a:contains(Remove)');

  andThen(function() {
    assert.equal(currentPath(), 'expenses.index');
    assert.deepEqual(confirmCalledWith, ['Are you sure?']);
    assert.equal(find('#blankslate').length, 1);
  });
});
