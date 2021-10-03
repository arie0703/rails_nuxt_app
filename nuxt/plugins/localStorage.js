import createPersistedState from 'vuex-persistedstate'

export default ({ store }) => {
    createPersistedState({
      paths: ['auth'],
      key: 'user_info'
    })(store);
};