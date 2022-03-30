# Comment uploader très simplement un fichier avec le framework Symfony 5, sans aucun Bundle

Pour bien structurer nos actions, nous allons créer et configurer :

1. Un service permettant d'uploader n'importe quel type de fichier dans un répertoire précis,
2. Un formulaire permettant d'appliquer des restrictions sur le fichier à uploader,
3. Un controller permettant de gérer l'ensemble des actions,
4. Une vue permettant de définir l'interface web.

## Création et configuration du service

Créons le code d'un service qui permettra l'upload de tout type de fichier, sans restriction :

```php
    // src/Service/FileUploader.php
    namespace App\Service;

    use Symfony\Component\HttpFoundation\File\Exception\FileException;
    use Symfony\Component\HttpFoundation\File\UploadedFile;
    use Symfony\Component\String\Slugger\SluggerInterface;

    class FileUploader
    {
        private $targetDirectory;
        private $slugger;
        public function __construct($targetDirectory, SluggerInterface $slugger)
        {
            $this->targetDirectory = $targetDirectory;
            $this->slugger = $slugger;
        }
        public function upload(UploadedFile $file)
        {
            $originalFilename = pathinfo($file->getClientOriginalName(), PATHINFO_FILENAME);
            $safeFilename = $this->slugger->slug($originalFilename);
            $fileName = $safeFilename.'-'.uniqid().'.'.$file->guessExtension();
            try {
                $file->move($this->getTargetDirectory(), $fileName);
            } catch (FileException $e) {
                // ... handle exception if something happens during file upload
                return null; // for example
            }
            return $fileName;
        }
        public function getTargetDirectory()
        {
            return $this->targetDirectory;
        }
    }
```

Il faut ensuite configurer ce service, notamment en lui passant le répertoire ou seront stockés tous les fichiers uploadés.

```yaml
    # config/services.yaml
    parameters:
        upload_directory: '%kernel.project_dir%/public/uploads'
    #...
    services:
        # ...
        App\Service\FileUploader:
            arguments:
                $targetDirectory: '%upload_directory%'
```

## Création et configuration du formulaire

```php
    <?php
    // src/Form/FileUploadType.php
    namespace App\Form;

    use Symfony\Component\Form\AbstractType;
    use Symfony\Component\Form\Extension\Core\Type\FileType;
    use Symfony\Component\Form\Extension\Core\Type\SubmitType;
    use Symfony\Component\Form\FormBuilderInterface;
    use Symfony\Component\OptionsResolver\OptionsResolver;
    use Symfony\Component\Validator\Constraints\File;
    
    class FileUploadType extends AbstractType
    {
        public function buildForm(FormBuilderInterface $builder, array $options)
        {
            $builder
                ->add('upload_file', FileType::class, [
                'label' => false,
                'mapped' => false, // Tell that there is no Entity to link
                'required' => true,
                'constraints' => [
                    new File([ 
                        'mimeTypes' => [ // We want to let upload only txt, csv or Excel files
                        'text/x-comma-separated-values', 
                        'text/comma-separated-values', 
                        'text/x-csv', 
                        'text/csv', 
                        'text/plain',
                        'application/octet-stream', 
                        'application/vnd.ms-excel', 
                        'application/x-csv', 
                        'application/csv', 
                        'application/excel', 
                        'application/vnd.msexcel', 
                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                        ],
                        'mimeTypesMessage' => "This document isn't valid.",
                    ])
                ],
            ])
            ->add('send', SubmitType::class); // We could have added it in the view, as stated in the framework recommendations
        }
    }
```

Vous trouverez sur la documentation Mozilla développeur (https://developer.mozilla.org/fr/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types) tous les types mimes possibles.

Création du controller

```php
    namespace App\Controller;

    use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
    use Symfony\Component\HttpFoundation\Request;
    use App\Service\FileUploader;
    use App\Form\FileUploadType;

    class UploadController extends BaseController
    {
        // ...
        /**
         * @Route("/test-upload", name="app_test_upload")
         */
        public function excelCommunesAction(Request $request, FileUploader $file_uploader)
        {
            $form = $this->createForm(FileUploadType::class);
            $form->handleRequest($request);

            if ($form->isSubmitted() && $form->isValid()) {
                $file = $form['upload_file']->getData();
                if ($file) {
                    $file_name = $file_uploader->upload($file);
                    if (null !== $file_name) {
                        $directory = $file_uploader->getTargetDirectory();
                        $full_path = $directory.'/'.$file_name;
                        // Do what you want with the full path file...
                        // Why not read the content or parse it !!!
                    }
                    else {
                        // Oups, an error occured !!!
                    }
                }
            }

            return $this->render('app/test-upload.html.twig', [
                'form' => $form->createView(),
            ]);
        }
        // ...
    }
```

## Création de la vue

Cette vue affichera notre formulaire récemment créée

```php
{# templates/app/test-upload.html.twig #}

{% extends 'app/layout.html.twig' %}

{% block title %}Upload test{% endblock %}

{% block description %}This page will render a simple form to upload a file.{% endblock %}

{% block content %}
    <div class="container container-fluid">
        <div class="row">
            <div class="col-lg-8">
            {{ form_start(form, { attr: { 'accept-charset' : 'utf-8' }}) }}
            <div class="form-group">
                {{ form_label(form.upload_file) }}
                {{ form_widget(form.upload_file) }}
                {{ form_errors(form.upload_file) }}
            </div>
            <div class="form-group">
                {{ form_widget(form.send, {'label': "Upload this file", 'attr' : { 'class': 'btn btn-primary' }}) }}
            </div>
            {{ form_rest(form) }}
            {{ form_end(form) }}
            </div>
        </div>
    </div>
{% endblock %}
```
Et voilà, vous savez maintenant comment uploader un fichier sans aucun bundle tiers !!!
