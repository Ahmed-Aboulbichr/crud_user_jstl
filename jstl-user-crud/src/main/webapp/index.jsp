<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Users Home</title>
<link rel="stylesheet" href="dist/css/style.css">

<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

	<sql:setDataSource var="base" driver="com.mysql.cj.jdbc.Driver" url="jdbc:mysql://localhost/datatest?serverTimezone=UTC" user="root" password="123456" />
	<c:if test="${ pageContext.request.method=='GET' && param.delete != null }" >
		<sql:update dataSource="${ base }" var="deleteUser">
			DELETE FROM user where login= ?
			<sql:param value="${ param.log }" />
		</sql:update>
	</c:if>
	<c:if test="${ pageContext.request.method=='POST' && param.ajouter != null }">
		<sql:update dataSource="${ base }" var="insertUser">
			INSERT INTO user(login, pwd, nom, prenom, email, role) VALUES(?, ?, ?, ?, ?, ?)
			<sql:param value="${param.login}" />
			<sql:param value="${param.pwd}" />
			<sql:param value="${param.nom}" />
			<sql:param value="${param.prenom}" />
			<sql:param value="${param.email}" />
			<sql:param value="${param.role}" />
		</sql:update>
	</c:if>
	<c:if test="${ pageContext.request.method=='POST' && param.editUser != null }">
		<sql:update dataSource="${base}" var="updateUser">
			UPDATE user set pwd=?, nom=?, prenom=?, email=?, role=?  where login=? 
			<sql:param value="${param.password}" />
			<sql:param value="${param.nom}" />
			<sql:param value="${param.prenom}" />
			<sql:param value="${param.email}" />
			<sql:param value="${param.role}" />
			<sql:param value="${param.login}" />
		</sql:update>
	</c:if>
	<c:if test="${ insertUser == 1 }">
		<script type="text/javascript">
			Swal.fire({
			  position: 'top-end',
			  icon: 'success',
			  title: 'Insertion Valide',
			  showConfirmButton: false,
			  timer: 1500
			})
		</script>
	</c:if>
	<c:if test="${ updateUser == 1 }">
		<script type="text/javascript">
			Swal.fire({
			  position: 'top-end',
			  icon: 'success',
			  title: 'Modifcation Valide',
			  showConfirmButton: false,
			  timer: 1500
			})
		</script>
	</c:if>
	<c:if test="${ deleteUser == 1 }">
		<script type="text/javascript">
			Swal.fire({
			  position: 'top-end',
			  icon: 'success',
			  title: 'Suppression Valide',
			  showConfirmButton: false,
			  timer: 1500
			})
		</script>
	</c:if>
	
	<sql:query dataSource="${base}" var="rs" sql="SELECT * FROM user" />
	<c:if test="${ pageContext.request.method=='POST' && param.btnSearch != null && param.txtSearch != '' }">
		<sql:query dataSource="${base}" var="rs">
			SELECT * FROM user where login=?
			<sql:param value="${ param.txtSearch }" />
		</sql:query>
	</c:if>

	<article class="container">
		<header class="container-header">
			<h2>Utilisateurs</h2>
			<button onclick="openModal()">Crée un utilisateur</button>
		</header>
		<main>
			<header>
				<form action="" method="POST">
					<input type="search" name="txtSearch">
					<input type="submit" value="Rechercher" name="btnSearch">
				</form>
				<button><i class="fas fa-arrow-circle-down"></i> Exporter</button>
			</header>
			<main>
				<table>
					<thead>
						<tr><th>Login</th><th>Prénom</th><th>Nom</th><th>Rôle</th><th>Action</th></tr>
					</thead>
					<tbody>
						<c:forEach var="row" items="${ rs.rows }">
							<tr>
								<td>${ row.login }</td>
								<td>${ row.prenom }</td>
								<td>${ row.nom }</td>
								<td>${ row.role }</td>
								<input type="hidden" value="${ row.email }" name="email" />	
								<input type="hidden" value="${ row.pwd }" name="password" />	
								<td>
									<i class="fas fa-user-edit" onclick="displayEditModal(this)"></i>
									<i class="fas fa-user-times" onclick="afficheConfirmation(this)"></i>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</main>
			<footer>footer</footer>
		</main>
		<footer class="footer"><i class="far fa-copyright"></i> -  crée par <strong><a href="https://github.com/Ahmed-Aboulbichr" >ABOULBICHR Ahmed</a></strong></footer>
	</article>
	
	<article id="editModal">
		<section class="editSection">
			<h1>Modifier Utilisateur.</h1>
			<form action="" method="POST">
				<input type="hidden" name="login" id="login">
				<div class="txtUser">
					<label for="password">Password</label>
					<input type="text" name="password" id="password">
				</div>
				<div class="txtUser">
					<label for="nom">Nom</label>
					<input type="text" name="nom" id="nom">
				</div>
				<div class="txtUser">
					<label for="prenom">Prénom</label>
					<input type="text" name="prenom" id="prenom">
				</div>
				<div class="txtUser">
					<label for="email">Email</label>
					<input type="text" name="email" id="email">
				</div>
				<div class="txtUser">
					<label for="role">Role</label>
					<input type="text" name="role" id="role">
				</div>
				<div class="footer">
					<input type="button" value="Annuler" onclick="removeModal()">
					<input type="submit" name="editUser" value="Modifier">
				</div>
			</form>
		</section>
	</article>
	
	<article id="addModal">
		<section class="addSection">
			<h1>Ajouter Utilisateur.</h1>
			<form action="" method="POST">
				<div class="txtUser">
					<label for="login">Login</label>
					<input type="text" name="login" id="addlogin">
				</div>
				<div class="txtUser">
					<label for="password">Password</label>
					<input type="text" name="password" id="addpassword">
				</div>
				<div class="txtUser">
					<label for="nom">Nom</label>
					<input type="text" name="nom" id="addnom">
				</div>
				<div class="txtUser">
					<label for="prenom">Prénom</label>
					<input type="text" name="prenom" id="addprenom">
				</div>
				<div class="txtUser">
					<label for="email">Email</label>
					<input type="text" name="email" id="addemail">
				</div>
				<div class="txtUser">
					<label for="role">Role</label>
					<input type="text" name="role" id="addrole">
				</div>
				<div class="footer">
					<input type="button" value="Annuler" onclick="removeEditModal()">
					<input type="submit" name="ajouter" value="Ajouter">
				</div>
			</form>
		</section>
	</article>
	
	<script src="https://kit.fontawesome.com/4c5ab858f3.js" crossorigin="anonymous"></script>
	<script type="text/javascript">
		function afficheConfirmation(btn){
			Swal.fire({
				  title: 'Are you sure?',
				  text: "You won't be able to revert this!",
				  icon: 'warning',
				  showCancelButton: true,
				  confirmButtonColor: '#3085d6',
				  cancelButtonColor: '#d33',
				  confirmButtonText: 'Yes, delete it!'
				}).then((result) => {
				  if (result.isConfirmed) {
					  login = btn.parentElement.parentElement.children[0].textContent;
				      location.href="?log="+login+"&delete=true";
				  }
				})
		}
		function openModal(){
			document.getElementById('addModal').classList.add("showModal");
		}
		function removeEditModal(){
			document.getElementById('addModal').classList.remove("showModal");
		}
		function displayEditModal(btn){
			document.getElementById('editModal').classList.add("showModal");
			array = btn.parentElement.parentElement.children
			document.getElementById('login').value= array[0].textContent;
			document.getElementById('password').value = array[5].value;
			document.getElementById('nom').value = array[2].textContent;
			document.getElementById('prenom').value = array[1].textContent;
			document.getElementById('email').value = array[4].value;
			document.getElementById('role').value = array[3].textContent;
		}
		function removeModal(){
			document.getElementById('editModal').classList.remove("showModal");
		}
	</script>
</body>
</html>