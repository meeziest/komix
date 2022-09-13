# simple_manga_translation

A computer-aided manga and comics translation tool. Computer-aided manga and comic translation tool can
automatically locate text areas and perform OCR operations and a homebrew text
area merging and detecting algorithm, which is specially designed for comics (also
webtoon, manga, manhwa and manhua). The original text can be automatically erased and the translation be reinjected.
For comfortable work with scanning, cleaning and reinjection for the user, it
was decided to choose the dart flutter framework. It allows to make a convenient
application for all platforms, including the desktop. To achieve a goal, it was
decided to make a desktop application. Since mobile devices are not suitable for
comfortable work with the translation process of our application.

![image](https://user-images.githubusercontent.com/61965947/189872442-4c134e71-dad8-4c25-8ff4-23f56611ee76.png)

The architecture for application was chosen as an improved MVP
(Model View Presenter) pattern. This pattern is difficult to understand but
very reliable for extending an application. Its essence is to have three layers -
presentation, domain, and data. The presentation layer consists of our streamenhanced MVP. Each user screen contains a model, a view itself, and a presenter.
For example, the authentication screen would consist of – authentication screen,
authentication model and authentication presenter.
The presenter layer is responsible for what happens under the soot, it works
with the model and can change it in every possible way. The model is the data
that the user should see on their screen. And the view uses this model to show the
data. View uses presenter streams to reactively change the interface. With
any change, the presenter throws a new model into the stream, while the view
catches it and rebuilds the interface. The next layer we have is domain, in essence
it is just interactors with a data layer. The data layer consists of repositories, we
need to send an asynchronous request to it. Therefore, our repositories consist of
a cloud store and a local store. The local store was made so that users would not
constantly have to load data from the backend and serves as a cache for application.
