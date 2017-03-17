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
          <div className="user-box search">
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
      <div className="user-form">
        <i className="fa fa-search"></i>
        <input type="text" placeholder="名前から検索" className="form-control" onChange={this.changeText}/>
      </div>
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
        <User key={user.id} id={user.id} image={user.image.url} name={user.name} />
      );
    });

    return (
      <div className="user-list">
        <div className="statement">
        {(() => {
          if (this.props.text !== "") {
            return (
              <span>
                名前で検索: "{this.props.text}"<br/>
              </span>
            );
          }
        })()}
          <span className="hit-num"> {userNodes.length} </span>
          人のユーザー
        </div>
        <div className="users">
          {userNodes}
      </div>
      </div>
    );
  }
});

var User = React.createClass({
  render: function() {
    return (
      <a href={'/users/' + this.props.id}>
        <li className="user">
          <div className="user-image">
            <img src={this.props.image} alt={this.props.name} width="70" height="70" />
          </div>
          <div className="user-name">
            {this.props.name}
          </div>
        </li>
      </a>
    )
  }
});
