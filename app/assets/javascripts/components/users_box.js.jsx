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
    return {data: [], text: ""};
  },
  componentDidMount: function() {
    this.loadCommentsFromServer();
    //setInterval(this.loadCommentsFromServer, this.props.pollInterval);
  },
  changeText(data){
    this.setState({ text: data.text });
  },
  render: function() {
    return (
      <div className="container">
        <div className="row">
          <div className="user-box">
            <UserForm onEventCallBack={this.changeText} />
            <UserList data={this.state.data} text={this.state.text} />
          </div>
        </div>
      </div>
    );
  }
});

var UserForm = React.createClass({
  changeText(e){
    this.props.onEventCallBack({ text : e.target.value });
    return
  },
  render: function() {
    return (
      <input type="text" placeholder="名前から絞る" onChange={this.changeText}/>
    );
  }
});

var UserList = React.createClass({
  render: function() {
    var filtering_text = this.props.text;
    var filtered_users = this.props.data.filter(function(user){
      return user.name.indexOf(filtering_text) != -1;
    });
    var userNodes = filtered_users.map(function (user) {
      return (
        <User key={user.id} image={user.image.url} name={user.name} />
      );
    });

    return (
      <div className="comment-list">
        <div className="statement">
        {(() => {
          if (this.props.text !== "") {
            return (
              <span>
                名前で検索: "{this.props.text}"
              </span>
            );
          }
        })()}
          <span className="hit_num">{userNodes.length}</span>
          件のユーザー
        </div>
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
