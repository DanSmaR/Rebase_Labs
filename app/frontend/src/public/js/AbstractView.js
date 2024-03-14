export default class {
  URL = '/data';

  constructor(params) {
    this.params = params;
  }

  setTitle(title) {
      document.title = title;
  }
}