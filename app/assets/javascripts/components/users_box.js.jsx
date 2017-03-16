var UserBox = React.createClass({
  loadCommentsFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(result) {
        this.setState({data: result.data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  getInitialState: function() {
    return {data: []};
  },
  componentDidMount: function() {
    this.loadCommentsFromServer();
    //setInterval(this.loadCommentsFromServer, this.props.pollInterval);
  },
  render: function() {
    return (
      <div className="container">
        <div className="row">
          <div className="user-box">
            <UserForm />
            <UserList data={this.state.data}  />
          </div>
        </div>
      </div>
    );
  }
});

var UserForm = React.createClass({
  render: function() {
    return (
      <div className="user-list">
        Hello, world! I am a UserForm.
      </div>
    );
  }
});

var UserList = React.createClass({
  render: function() {
    var userNodes = this.props.data.map(function (user) {
      return (
        <User image={user.image.url} name={user.name} />
      );
    });
    return (
      <div className="comment-list">
        {userNodes}
      </div>
    );
  }
});

var User = React.createClass({
  render: function() {
    return (
      <div className="user">
        <div className="user-image">
          <img src={this.props.image} alt={this.props.name} width="50" height="50" />
        </div>
        <h3 className="user-name">
          {this.props.name}
        </h3>
      </div>
    )
  }
});
