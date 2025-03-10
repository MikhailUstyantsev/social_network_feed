# social_network_feed
Небольшой тестовый проект, который представляет из себя моковую социальную сеть для разработчиков. В качестве бекэнда используется https://developers.forem.com/api/v1#tag/articles/operation/getArticles
Приложение включает в себя детальный экран, с возможностью просмотра комментариев к посту, а также список статей сохраненных для оффлайн доступа. (При необходимости, аналогично закладкам, можно реализовать лайки)


Технические особенности:

- Архитектура MVVM
- Фреймворк для работы с сетью Alamofire
- Отдельные слои для работы с API и постоянным хранилищем (Core Data)
- 100% интерфейс UIKit (кодом)
- В качестве датасорса таблицы использован UITableViewDiffableDataSource
_____________
<div align="center">
  <img src="https://github.com/MikhailUstyantsev/social_network_feed/blob/main/Logo.png" width="300px" />
</div>
<div align="center">
  <b>
  Лого проекта
</div>

_____________

<div align="center">
  <img src="https://github.com/MikhailUstyantsev/social_network_feed/blob/main/Posts%20feed.png" width="300"/>
</div>
<div align="center">
  <b>
     Стартовый экран
  </b>
</div>

______________

<div align="center">
  <img src="https://github.com/MikhailUstyantsev/social_network_feed/blob/main/Comments%20are%20hidden.png" width="300"/>
</div>
<div align="center">
  <b>
     Секция с комментариями скрыта 
  </b>
</div>


______________

<div align="center">
  <img src="https://github.com/MikhailUstyantsev/social_network_feed/blob/main/Comments.png" width="300"/>
</div>
<div align="center">
  <b>
     Секция с комментариями развернута 
  </b>
</div>


______________

<div align="center">
  <img src="https://github.com/MikhailUstyantsev/social_network_feed/blob/main/Delete%20action%20sheet.png" width="300"/>
</div>
<div align="center">
  <b>
     Удаление статьи из избранного 
  </b>
</div>
